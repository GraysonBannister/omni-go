import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../data/models/agent_event.dart';
import '../core/errors/failures.dart';
import '../config/constants.dart';

typedef EventCallback = void Function(AgentEvent event);
typedef ErrorCallback = void Function(Failure error);

class SseService {
  http.Client? _client;
  StreamSubscription<String>? _subscription;
  Timer? _reconnectTimer;

  bool _isConnected = false;
  String? _baseUrl;
  String? _apiKey;
  String? _conversationId;
  String? _terminalId;

  // Exponential backoff state
  int _retryCount = 0;
  static const int _maxRetryDelayMs = 30000; // Max 30 seconds
  static const int _jitterMaxMs = 1000; // Max 1 second jitter

  EventCallback? _onEvent;
  ErrorCallback? _onError;
  VoidCallback? _onConnect;
  VoidCallback? _onDisconnect;

  bool get isConnected => _isConnected;

  void configure(String baseUrl, String apiKey) {
    _baseUrl = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    _apiKey = apiKey;
  }

  void connectToAgentEvents(
    String conversationId, {
    required EventCallback onEvent,
    ErrorCallback? onError,
    VoidCallback? onConnect,
    VoidCallback? onDisconnect,
  }) {
    _reconnectTimer?.cancel();
    _terminalId = null;
    _conversationId = conversationId;
    _onEvent = onEvent;
    _onError = onError;
    _onConnect = onConnect;
    _onDisconnect = onDisconnect;

    _connect();
  }

  void connectToTerminal(
    String terminalId, {
    required EventCallback onEvent,
    ErrorCallback? onError,
    VoidCallback? onConnect,
    VoidCallback? onDisconnect,
  }) {
    _reconnectTimer?.cancel();
    _conversationId = null;
    _terminalId = terminalId;
    _onEvent = onEvent;
    _onError = onError;
    _onConnect = onConnect;
    _onDisconnect = onDisconnect;

    _connectToTerminal();
  }

  void _connect() {
    if (_baseUrl == null || _apiKey == null) {
      _onError?.call(const AuthenticationFailure('Not configured'));
      return;
    }

    final url = '$_baseUrl${ApiEndpoints.events}?conversationId=$_conversationId';
    _startStream(url);
  }

  void _connectToTerminal() {
    if (_baseUrl == null || _apiKey == null) {
      _onError?.call(const AuthenticationFailure('Not configured'));
      return;
    }

    final url = '$_baseUrl${ApiEndpoints.terminalStream}/$_terminalId';
    _startStream(url);
  }

  void _startStream(String url) {
    if (kDebugMode) debugPrint('[SseService] _startStream: url=$url');
    try {
      _client?.close();
      _client = http.Client();

      final request = http.Request('GET', Uri.parse(url));
      request.headers['Accept'] = 'text/event-stream';
      request.headers['X-API-Key'] = _apiKey!;
      request.headers['Cache-Control'] = 'no-cache';

      // HMAC request signature to prevent replay attacks.
      // Signing string: "GET\nPATH_WITH_QUERY\nTIMESTAMP"
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final parsedUri = Uri.parse(url);
      final rawPath = parsedUri.path +
          (parsedUri.hasQuery ? '?${parsedUri.query}' : '');
      final signingString = 'GET\n$rawPath\n$timestamp';
      final hmac = Hmac(sha256, utf8.encode(_apiKey!));
      request.headers['X-Timestamp'] = timestamp;
      request.headers['X-Signature'] =
          hmac.convert(utf8.encode(signingString)).toString();

      _client!.send(request).then((response) {
        if (kDebugMode) debugPrint('[SseService] _startStream: HTTP ${response.statusCode}');
        if (response.statusCode == 200) {
          // Reset retry count on successful connection
          _retryCount = 0;
          _isConnected = true;
          _onConnect?.call();
          if (kDebugMode) debugPrint('[SseService] _startStream: connected, listening for events');

          final stream = response.stream
              .transform(utf8.decoder)
              .transform(const LineSplitter());

          _subscription = stream.listen(
            _handleLine,
            onError: (error) {
              if (kDebugMode) debugPrint('[SseService] _startStream: stream error: $error');
              _handleError(error);
            },
            onDone: () {
              if (kDebugMode) debugPrint('[SseService] _startStream: stream done (server closed connection)');
              _handleDisconnect();
            },
            cancelOnError: false,
          );
        } else {
          if (kDebugMode) debugPrint('[SseService] _startStream: non-200, calling _handleError');
          _handleError('HTTP ${response.statusCode}');
        }
      }).catchError((error) {
        if (kDebugMode) debugPrint('[SseService] _startStream: catchError: $error');
        _handleError(error);
      });
    } catch (e) {
      if (kDebugMode) debugPrint('[SseService] _startStream: sync exception: $e');
      _handleError(e);
    }
  }

  void _handleLine(String line) {
    if (kDebugMode) {
      debugPrint('[SseService:data] Raw SSE line: "$line"');
    }
    if (line.isEmpty) {
      if (kDebugMode) {
        debugPrint('[SseService:data] Empty line received, skipping');
      }
      return;
    }
    if (line.startsWith(':')) {
      if (kDebugMode) {
        debugPrint('[SseService:data] Comment/keepalive line received');
      }
      return;
    }

    if (line.startsWith('data: ')) {
      final data = line.substring(6);
      if (kDebugMode) {
        debugPrint('[SseService:data] Received SSE data: $data');
      }
      try {
        final json = jsonDecode(data) as Map<String, dynamic>;
        if (kDebugMode) {
          debugPrint('[SseService:data] JSON parsed successfully');
          debugPrint('[SseService:data] JSON type=${json['type']}, eventType=${json['eventType']}');
          // Log all keys for debugging
          debugPrint('[SseService:data] JSON keys: ${json.keys.toList()}');
        }

        // Check for error events specifically
        final eventType = json['type']?.toString().toLowerCase() ?? '';
        if (eventType == 'error' || json['eventType']?.toString().toLowerCase() == 'error') {
          if (kDebugMode) {
            debugPrint('[SseService:error] ERROR EVENT RECEIVED');
            debugPrint('[SseService:error] Error data: ${json['error'] ?? json['message'] ?? json}');
            debugPrint('[SseService:error] Full error JSON: $json');
          }
        }

        final event = AgentEvent.fromSseData(json, _conversationId);
        if (kDebugMode) {
          debugPrint('[SseService:data] Event parsed successfully: type=${event.type}');
        }
        _onEvent?.call(event);
      } catch (e, stackTrace) {
        if (kDebugMode) {
          debugPrint('[SseService:error] FAILED to parse SSE data: $e');
          debugPrint('[SseService:error] Stack trace: $stackTrace');
          debugPrint('[SseService:error] Raw data that failed: "$data"');
        }
      }
    } else {
      if (kDebugMode) {
        debugPrint('[SseService:data] Non-data line received: "$line"');
      }
    }
  }

  void _handleError(dynamic error) {
    _isConnected = false;

    Failure failure;
    final errorString = error.toString().toLowerCase();

    if (error is String) {
      if (error.contains('401')) {
        failure = const AuthenticationFailure('Invalid API key');
      } else if (error.contains('Failed host lookup') ||
                 error.contains('nodename nor servname provided') ||
                 error.contains('no address associated with hostname') ||
                 error.contains('enoent') ||
                 error.contains('eai_again') ||
                 error.contains('dns')) {
        // DNS/host lookup failure - server may be unreachable or URL expired
        failure = const NetworkFailure(
          'Cannot reach server. The connection may have expired or your internet is offline. '
          'Please check your connection or reconnect in settings.'
        );
      } else if (error.contains('timeout') || error.contains('SocketException')) {
        failure = const NetworkFailure('Connection failed. Please check your internet connection.');
      } else {
        failure = NetworkFailure(error);
      }
    } else {
      // Check for socket exceptions wrapped in other error types
      if (errorString.contains('socketexception') &&
          (errorString.contains('failed host lookup') ||
           errorString.contains('no address associated'))) {
        failure = const NetworkFailure(
          'Cannot reach server. The connection may have expired or your internet is offline. '
          'Please check your connection or reconnect in settings.'
        );
      } else {
        failure = NetworkFailure(error.toString());
      }
    }

    _onError?.call(failure);
    _scheduleReconnect();
  }

  void _handleDisconnect() {
    if (kDebugMode) debugPrint('[SseService] _handleDisconnect: terminalId=$_terminalId conversationId=$_conversationId');
    _isConnected = false;
    _onDisconnect?.call();
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    // Calculate exponential backoff with jitter
    // delay = min(baseDelay * 2^retryCount + jitter, maxDelay)
    final baseDelay = AppConstants.sseRetryDelay;
    final exponentialDelay = baseDelay * (1 << _retryCount); // baseDelay * 2^retryCount
    final jitter = Random().nextInt(_jitterMaxMs); // 0-1000ms random
    final delayMs = min(exponentialDelay + jitter, _maxRetryDelayMs);

    // Increment retry count for next time (capped to prevent overflow)
    if (_retryCount < 10) _retryCount++;

    if (kDebugMode) {
      debugPrint('[SseService] _scheduleReconnect: attempt=$_retryCount, delay=${delayMs}ms (base=${baseDelay}ms * 2^${_retryCount - 1} + ${jitter}ms jitter)');
    }

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(
      Duration(milliseconds: delayMs),
      () {
        if (!_isConnected) {
          if (kDebugMode) debugPrint('[SseService] _scheduleReconnect: timer fired, reconnecting (terminalId=$_terminalId, attempt=$_retryCount)');
          if (_terminalId != null) {
            _connectToTerminal();
          } else {
            _connect();
          }
        } else {
          if (kDebugMode) debugPrint('[SseService] _scheduleReconnect: timer fired but already connected, skipping');
        }
      },
    );
  }

  /// Immediately attempt to reconnect, bypassing any pending exponential backoff.
  /// Call this when the app returns from background and you want to reconnect quickly.
  void reconnectImmediately() {
    if (kDebugMode) {
      debugPrint('[SseService] reconnectImmediate: resetting retry count and connecting now');
    }

    _reconnectTimer?.cancel();
    _retryCount = 0;

    if (_isConnected) {
      if (kDebugMode) debugPrint('[SseService] reconnectImmediate: already connected');
      return;
    }

    if (_terminalId != null) {
      _connectToTerminal();
    } else if (_conversationId != null) {
      _connect();
    } else {
      if (kDebugMode) debugPrint('[SseService] reconnectImmediate: no active conversation/terminal to reconnect to');
    }
  }

  /// Reset the retry count without triggering a reconnection.
  /// Useful when you want to clear backoff state but don't want to connect yet.
  void resetRetryCount() {
    if (kDebugMode) {
      debugPrint('[SseService] resetRetryCount: clearing retry count from $_retryCount to 0');
    }
    _retryCount = 0;
  }

  void disconnect() {
    _isConnected = false;
    _retryCount = 0; // Reset retry count on manual disconnect
    _reconnectTimer?.cancel();
    _subscription?.cancel();
    _client?.close();
    _client = null;
    _terminalId = null;
    _conversationId = null;
    _onDisconnect?.call();
  }

  void dispose() {
    disconnect();
    _onEvent = null;
    _onError = null;
    _onConnect = null;
    _onDisconnect = null;
  }
}
