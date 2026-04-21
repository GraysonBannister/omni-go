import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../config/constants.dart';
import '../../core/errors/failures.dart';
import '../../data/models/server_config.dart';
import '../../data/models/connection_health.dart';
import '../../data/repositories/remote_repository.dart';
import '../../services/api_service.dart';
import '../../services/notification_service.dart';
import '../../services/sse_service.dart';

part 'server_provider.g.dart';

const _secureStorage = FlutterSecureStorage();

@Riverpod(keepAlive: true)
class ServerConnection extends _$ServerConnection {
  RemoteRepository? _repository;
  int _reconnectCount = 0;
  DateTime? _lastConnectedAt;
  DateTime? _lastDisconnectedAt;
  int? _lastLatencyMs;
  String? _lastError;

  @override
  ServerConfig build() {
    _loadSavedConfig();
    return ServerConfig.empty();
  }

  /// Get current connection health metrics
  ConnectionHealth get connectionHealth {
    final isConnected = state.isConnected;
    final isHealthy = isConnected && (_lastLatencyMs == null || _lastLatencyMs! < 1000);

    return ConnectionHealth(
      isConnected: isConnected,
      isHealthy: isHealthy,
      latencyMs: _lastLatencyMs,
      reconnectCount: _reconnectCount,
      lastConnectedAt: _lastConnectedAt,
      lastDisconnectedAt: _lastDisconnectedAt,
      lastError: _lastError,
    );
  }

  Future<void> _loadSavedConfig() async {
    try {
      final url = await _secureStorage.read(key: StorageKeys.serverUrl);
      final apiKey = await _secureStorage.read(key: StorageKeys.apiKey);

      if (url != null && apiKey != null) {
        state = state.copyWith(url: url, apiKey: apiKey);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to load saved config: $e');
      }
    }
  }

  Future<void> _saveConfig() async {
    try {
      await _secureStorage.write(key: StorageKeys.serverUrl, value: state.url);
      await _secureStorage.write(key: StorageKeys.apiKey, value: state.apiKey);
      await _secureStorage.write(
        key: StorageKeys.lastConnectedAt,
        value: DateTime.now().toIso8601String(),
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to save config: $e');
      }
    }
  }

  Future<bool> get hasSavedConfig async {
    try {
      final url = await _secureStorage.read(key: StorageKeys.serverUrl);
      final apiKey = await _secureStorage.read(key: StorageKeys.apiKey);
      return url != null &&
          url.isNotEmpty &&
          apiKey != null &&
          apiKey.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, String?>> getSavedConfig() async {
    try {
      final url = await _secureStorage.read(key: StorageKeys.serverUrl);
      final apiKey = await _secureStorage.read(key: StorageKeys.apiKey);
      final lastConnectedAt = await _secureStorage.read(
        key: StorageKeys.lastConnectedAt,
      );
      return {'url': url, 'apiKey': apiKey, 'lastConnectedAt': lastConnectedAt};
    } catch (e) {
      return {'url': null, 'apiKey': null, 'lastConnectedAt': null};
    }
  }

  Future<void> reconnect() async {
    final savedConfig = await getSavedConfig();
    final url = savedConfig['url'];
    final apiKey = savedConfig['apiKey'];

    if (url == null ||
        url.isEmpty ||
        apiKey == null ||
        apiKey.isEmpty) {
      state = state.copyWith(
        error: 'No saved connection found. Please enter URL and API key.',
      );
      return;
    }

    state = state.copyWith(url: url, apiKey: apiKey, isLoading: true, error: null);
    await connect();
  }

  /// Test the current connection without changing state.
  /// Returns true if the server is reachable, false otherwise.
  Future<bool> testCurrentConnection() async {
    if (!isConfigured || state.url.isEmpty || state.apiKey.isEmpty) {
      return false;
    }

    try {
      final apiService = ApiService();
      apiService.configure(state.url, state.apiKey);
      return await apiService.testConnection();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[ServerConnection] Connection test failed: $e');
      }
      return false;
    }
  }

  /// Verify connection and reconnect if needed.
  /// Call this when returning from background to ensure connection is still valid.
  Future<bool> verifyAndReconnect() async {
    if (!isConfigured) {
      return false;
    }

    // Quick test first
    final startTime = DateTime.now();
    final isStillConnected = await testCurrentConnection();
    _lastLatencyMs = DateTime.now().difference(startTime).inMilliseconds;

    if (isStillConnected) {
      // Connection is good, just make sure state reflects that
      if (!state.isConnected) {
        state = state.copyWith(isConnected: true, error: null);
        _lastConnectedAt = DateTime.now();
      }
      return true;
    }

    // Connection lost - attempt to reconnect
    if (kDebugMode) {
      debugPrint('[ServerConnection] Connection lost during background, attempting reconnect');
    }

    _reconnectCount++;
    _lastDisconnectedAt = DateTime.now();

    // Reinitialize the repository
    await connect();

    return state.isConnected;
  }

  void updateUrl(String url) {
    state = state.copyWith(url: url, error: null);
  }

  void updateApiKey(String apiKey) {
    state = state.copyWith(apiKey: apiKey, error: null);
  }

  Future<void> connect() async {
    if (state.url.isEmpty || state.apiKey.isEmpty) {
      state = state.copyWith(error: 'Please enter both URL and API key');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    // Track connection attempt timing
    final startTime = DateTime.now();

    try {
      final apiService = ApiService();
      final sseService = SseService();
      _repository = RemoteRepository(apiService, sseService);
      _repository!.configure(state.url, state.apiKey);

      final result = await _repository!.testConnection();

      // Calculate connection latency
      _lastLatencyMs = DateTime.now().difference(startTime).inMilliseconds;

      if (result.isConnected) {
        _lastConnectedAt = DateTime.now();
        _lastError = null;
        _reconnectCount = 0;
        state = result.copyWith(isLoading: false);
        await _saveConfig();

        // Request notification permissions after successful connection
        // This is a good time to ask since the user has just successfully connected
        if (kDebugMode) {
          debugPrint('[ServerConnection] Requesting notification permissions');
        }
        await NotificationService().requestPermissions();
      } else {
        _lastDisconnectedAt = DateTime.now();
        _lastError = result.error ?? 'Connection failed';
        state = state.copyWith(
          isLoading: false,
          isConnected: false,
          error: result.error ?? 'Connection failed',
        );
      }
    } on Failure catch (e) {
      _lastDisconnectedAt = DateTime.now();
      _lastError = e.message;
      _lastLatencyMs = null;
      state = state.copyWith(
        isLoading: false,
        isConnected: false,
        error: e.message,
      );
    } catch (e) {
      _lastDisconnectedAt = DateTime.now();
      _lastError = e.toString();
      _lastLatencyMs = null;
      state = state.copyWith(
        isLoading: false,
        isConnected: false,
        error: e.toString(),
      );
    }
  }

  Future<void> disconnect() async {
    _repository?.dispose();
    _repository = null;
    _lastDisconnectedAt = DateTime.now();
    _lastLatencyMs = null;
    state = state.copyWith(isConnected: false);

    await _secureStorage.delete(key: StorageKeys.serverUrl);
    await _secureStorage.delete(key: StorageKeys.apiKey);
    await _secureStorage.delete(key: StorageKeys.lastConnectedAt);
  }

  RemoteRepository? get repository => _repository;

  bool get isConfigured => state.url.isNotEmpty && state.apiKey.isNotEmpty;
}

@riverpod
RemoteRepository remoteRepository(RemoteRepositoryRef ref) {
  final serverConnection = ref.watch(serverConnectionProvider);
  
  if (!serverConnection.isConnected) {
    throw StateError('Not connected to server');
  }

  final apiService = ApiService();
  final sseService = SseService();
  final repository = RemoteRepository(apiService, sseService);
  repository.configure(serverConnection.url, serverConnection.apiKey);
  
  return repository;
}
