import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../data/models/agent_event.dart';
import '../core/errors/failures.dart';
import '../config/constants.dart';

typedef EventCallback = void Function(AgentEvent event);
typedef ErrorCallback = void Function(Failure error);

/// Real-time event service using WebSocket instead of SSE.
/// Cloudflare tunnels buffer SSE responses but properly proxy WebSocket.
class SseService {
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  Timer? _reconnectTimer;
  Timer? _pingTimer;
  Timer? _pongTimeoutTimer;

  bool _isConnected = false;
  bool _isInBackground = false;
  String? _baseUrl;
  String? _apiKey;
  String? _conversationId;
  String? _terminalId;

  int _retryCount = 0;
  static const int _maxRetryDelayMs = 30000;
  static const int _jitterMaxMs = 1000;

  // Keep-alive constants
  static const int _pingIntervalMs = 30000; // 30 seconds
  static const int _pongTimeoutMs = 10000; // 10 seconds

  // Event tracking for missed event detection
  DateTime? _lastEventTimestamp;
  int? _lastEventId;

  EventCallback? _onEvent;
  ErrorCallback? _onError;
  VoidCallback? _onConnect;
  VoidCallback? _onDisconnect;
  VoidCallback? _onMissedEvents;

  bool get isConnected => _isConnected;
  DateTime? get lastEventTimestamp => _lastEventTimestamp;
  int? get lastEventId => _lastEventId;

  void configure(String baseUrl, String apiKey) {
    _baseUrl = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    _apiKey = apiKey;
  }

  /// Called when app goes to background
  void onAppBackgrounded() {
    if (kDebugMode) {
      debugPrint('[WsService] App backgrounded, pausing keep-alive');
    }
    _isInBackground = true;
    _stopPingTimer();
  }

  /// Called when app returns to foreground
  void onAppResumed() {
    if (kDebugMode) {
      debugPrint('[WsService] App resumed, resuming keep-alive');
    }
    _isInBackground = false;
    if (_isConnected) {
      _startPingTimer();
    }
  }

  void _startPingTimer() {
    _stopPingTimer();
    if (_isInBackground) return; // Don't ping in background

    _pingTimer = Timer.periodic(
      const Duration(milliseconds: _pingIntervalMs),
      (_) => _sendPing(),
    );

    // Send initial ping
    _sendPing();
  }

  void _stopPingTimer() {
    _pingTimer?.cancel();
    _pingTimer = null;
    _pongTimeoutTimer?.cancel();
    _pongTimeoutTimer = null;
  }

  void _sendPing() {
    if (_channel == null || !_isConnected) return;

    try {
      // Send a ping message - server should respond with pong
      final pingMsg = jsonEncode({'type': 'ping', 'timestamp': DateTime.now().millisecondsSinceEpoch});
      _channel!.sink.add(pingMsg);

      if (kDebugMode) {
        debugPrint('[WsService] Ping sent');
      }

      // Set up pong timeout
      _pongTimeoutTimer?.cancel();
      _pongTimeoutTimer = Timer(
        const Duration(milliseconds: _pongTimeoutMs),
        _handlePongTimeout,
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[WsService] Failed to send ping: $e');
      }
    }
  }

  void _handlePong(dynamic data) {
    // Cancel pong timeout
    _pongTimeoutTimer?.cancel();
    _pongTimeoutTimer = null;

    if (kDebugMode) {
      debugPrint('[WsService] Pong received');
    }
  }

  void _handlePongTimeout() {
    if (kDebugMode) {
      debugPrint('[WsService] Pong timeout - connection may be stale');
    }
    // Don't disconnect if we're in the background - iOS delays pong responses
    // and we want to keep the connection alive to receive turn_complete events
    if (_isInBackground) {
      if (kDebugMode) {
        debugPrint('[WsService] Ignoring pong timeout while backgrounded');
      }
      return;
    }
    _handleDisconnect();
  }

  void _updateLastEventTimestamp() {
    _lastEventTimestamp = DateTime.now();
    _lastEventId = (_lastEventId ?? 0) + 1;
  }

  void connectToAgentEvents(
    String conversationId, {
    required EventCallback onEvent,
    ErrorCallback? onError,
    VoidCallback? onConnect,
    VoidCallback? onDisconnect,
    VoidCallback? onMissedEvents,
  }) {
    _reconnectTimer?.cancel();
    _terminalId = null;
    _conversationId = conversationId;
    _onEvent = onEvent;
    _onError = onError;
    _onConnect = onConnect;
    _onDisconnect = onDisconnect;
    _onMissedEvents = onMissedEvents;

    _connectWebSocket();
  }

  void connectToTerminal(
    String terminalId, {
    required EventCallback onEvent,
    ErrorCallback? onError,
    VoidCallback? onConnect,
    VoidCallback? onDisconnect,
    VoidCallback? onMissedEvents,
  }) {
    _reconnectTimer?.cancel();
    _conversationId = null;
    _terminalId = terminalId;
    _onEvent = onEvent;
    _onError = onError;
    _onConnect = onConnect;
    _onDisconnect = onDisconnect;
    _onMissedEvents = onMissedEvents;

    _connectWebSocket();
  }

  void _connectWebSocket() {
    // Wrap connection in error zone to catch async errors
    runZonedGuarded(
      () => _performConnection(),
      (error, stack) {
        if (kDebugMode) debugPrint('[WsService] Zone error: $error');
        _handleError(error);
      },
    );
  }

  void _performConnection() async {
    if (_baseUrl == null || _apiKey == null) {
      _onError?.call(const AuthenticationFailure('Not configured'));
      return;
    }

    _closeChannel();

    // Convert http(s) to ws(s)
    final wsUrl = _baseUrl!
        .replaceFirst('https://', 'wss://')
        .replaceFirst('http://', 'ws://');
    final uri = Uri.parse('$wsUrl${ApiEndpoints.ws}');

    // HMAC auth headers on the upgrade request
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final rawPath = uri.path + (uri.hasQuery ? '?${uri.query}' : '');
    final signingString = 'GET\n$rawPath\n$timestamp';
    final hmac = Hmac(sha256, utf8.encode(_apiKey!));
    final signature = hmac.convert(utf8.encode(signingString)).toString();

    if (kDebugMode) {
      debugPrint('[WsService] Connecting to $uri');
    }

    try {
      // Create the WebSocket channel
      _channel = IOWebSocketChannel.connect(
        uri,
        headers: {
          'X-API-Key': _apiKey!,
          'X-Timestamp': timestamp,
          'X-Signature': signature,
        },
      );

      // Set up stream listener with error handling
      _subscription = _channel!.stream.listen(
        _handleMessage,
        onError: (error) {
          if (kDebugMode) debugPrint('[WsService] Stream error: $error');
          _handleError(error);
        },
        onDone: () {
          if (kDebugMode) {
            debugPrint('[WsService] Connection closed (code=${_channel?.closeCode}, reason=${_channel?.closeReason})');
          }
          _handleDisconnect();
        },
        cancelOnError: false,
      );

      // The WebSocket handshake is async — we consider ourselves connected
      // once the stream is listening. Send subscription immediately.
      _retryCount = 0;
      _isConnected = true;
      _onConnect?.call();

      // Start keep-alive ping timer
      _startPingTimer();

      _sendSubscription();

      // Handle any async connection errors that might occur after setup
      // ignore: unawaited_futures
      _channel!.sink.done.catchError((e) {
        if (kDebugMode) debugPrint('[WsService] Sink done error: $e');
      });
    } catch (e) {
      if (kDebugMode) debugPrint('[WsService] Connect exception: $e');
      _handleError(e);
    }
  }

  void _sendSubscription() {
    if (_channel == null) return;

    if (_conversationId != null) {
      final msg = jsonEncode({
        'type': 'subscribe',
        'channel': 'agent',
        'conversationId': _conversationId,
      });
      if (kDebugMode) debugPrint('[WsService] Sending agent subscribe: $_conversationId');
      _channel!.sink.add(msg);
    } else if (_terminalId != null) {
      final msg = jsonEncode({
        'type': 'subscribe',
        'channel': 'terminal',
        'terminalId': _terminalId,
      });
      if (kDebugMode) debugPrint('[WsService] Sending terminal subscribe: $_terminalId');
      _channel!.sink.add(msg);
    }
  }

  void _handleMessage(dynamic raw) {
    final data = raw.toString();
    if (kDebugMode) {
      final preview = data.length > 200 ? '${data.substring(0, 200)}...' : data;
      debugPrint('[WsService] Message: $preview');
    }

    try {
      final json = jsonDecode(data) as Map<String, dynamic>;
      final type = json['type'] as String?;

      // Handle ping/pong keep-alive
      if (type == 'ping') {
        // Respond to server ping with pong
        _sendPong(json['timestamp'] as int?);
        return;
      }
      if (type == 'pong') {
        _handlePong(json);
        return;
      }

      // Handle sync response - server is telling us about missed events
      if (type == 'sync') {
        final hasMissedEvents = json['hasMissedEvents'] as bool? ?? false;
        if (hasMissedEvents) {
          if (kDebugMode) {
            debugPrint('[WsService] Missed events detected via sync');
          }
          _onMissedEvents?.call();
        }
        return;
      }

      // Ignore protocol-level acks
      if (type == 'subscribed' || type == 'unsubscribed') {
        if (kDebugMode) debugPrint('[WsService] Subscription ack: $type');
        return;
      }

      // Track event timestamp for missed event detection
      _updateLastEventTimestamp();

      // Parse as AgentEvent — same path as old SSE parsing
      final event = AgentEvent.fromSseData(json, _conversationId);
      if (kDebugMode) {
        debugPrint('[WsService] Event parsed: type=${event.type}');
      }
      _onEvent?.call(event);
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('[WsService] Parse error: $e');
        debugPrint('[WsService] Stack: $stackTrace');
        debugPrint('[WsService] Raw: "$data"');
      }
    }
  }

  void _sendPong(int? originalTimestamp) {
    if (_channel == null) return;

    try {
      final pongMsg = jsonEncode({
        'type': 'pong',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'originalTimestamp': originalTimestamp,
      });
      _channel!.sink.add(pongMsg);

      if (kDebugMode) {
        debugPrint('[WsService] Pong sent');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[WsService] Failed to send pong: $e');
      }
    }
  }

  /// Request sync of missed events since the given timestamp.
  /// This should be called when returning from background.
  void requestSync(DateTime? since) {
    if (_channel == null || !_isConnected) return;

    try {
      final syncMsg = jsonEncode({
        'type': 'sync',
        'since': since?.millisecondsSinceEpoch,
        'lastEventId': _lastEventId,
        'conversationId': _conversationId,
      });
      _channel!.sink.add(syncMsg);

      if (kDebugMode) {
        debugPrint('[WsService] Sync requested since: $since');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[WsService] Failed to request sync: $e');
      }
    }
  }

  void _handleError(dynamic error) {
    _isConnected = false;

    Failure failure;
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('401') || errorString.contains('unauthorized')) {
      failure = const AuthenticationFailure('Invalid API key');
    } else if (errorString.contains('failed host lookup') ||
               errorString.contains('nodename nor servname provided') ||
               errorString.contains('no address associated with hostname') ||
               errorString.contains('enoent') ||
               errorString.contains('eai_again') ||
               errorString.contains('dns')) {
      failure = const NetworkFailure(
        'Cannot reach server. The connection may have expired or your internet is offline. '
        'Please check your connection or reconnect in settings.',
      );
    } else if (errorString.contains('timeout') || errorString.contains('socketexception')) {
      failure = const NetworkFailure('Connection failed. Please check your internet connection.');
    } else {
      failure = NetworkFailure(error.toString());
    }

    _onError?.call(failure);
    _scheduleReconnect();
  }

  void _handleDisconnect() {
    if (kDebugMode) {
      debugPrint('[WsService] Disconnected: terminalId=$_terminalId conversationId=$_conversationId');
    }
    _isConnected = false;
    _onDisconnect?.call();
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    const baseDelay = AppConstants.sseRetryDelay;
    final exponentialDelay = baseDelay * (1 << _retryCount);
    final jitter = Random().nextInt(_jitterMaxMs);
    final delayMs = min(exponentialDelay + jitter, _maxRetryDelayMs);

    if (_retryCount < 10) _retryCount++;

    if (kDebugMode) {
      debugPrint('[WsService] Reconnect in ${delayMs}ms (attempt=$_retryCount)');
    }

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(
      Duration(milliseconds: delayMs),
      () {
        if (!_isConnected && (_conversationId != null || _terminalId != null)) {
          _connectWebSocket();
        }
      },
    );
  }

  void reconnectImmediately() {
    if (kDebugMode) debugPrint('[WsService] reconnectImmediately');
    _reconnectTimer?.cancel();
    _retryCount = 0;
    if (_isConnected) return;
    if (_conversationId != null || _terminalId != null) {
      _connectWebSocket();
    }
  }

  void resetRetryCount() {
    _retryCount = 0;
  }

  void _closeChannel() {
    _subscription?.cancel();
    _subscription = null;
    try {
      _channel?.sink.close();
    } catch (_) {}
    _channel = null;
  }

  void disconnect() {
    _isConnected = false;
    _retryCount = 0;
    _reconnectTimer?.cancel();
    _stopPingTimer();
    _closeChannel();
    _terminalId = null;
    _conversationId = null;
    _onDisconnect?.call();
  }

  void dispose() {
    disconnect();
    _stopPingTimer();
    _onEvent = null;
    _onError = null;
    _onConnect = null;
    _onDisconnect = null;
    _onMissedEvents = null;
  }
}
