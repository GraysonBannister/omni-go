import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/providers/chat_provider.dart';
import '../../presentation/providers/server_provider.dart';
import '../../services/notification_service.dart';

/// Observes app lifecycle changes and manages connection state.
///
/// When the app is backgrounded, connections may be dropped by the OS.
/// When the app returns to foreground, we need to:
/// 1. Check if the connection is still valid
/// 2. Reset any exponential backoff timers
/// 3. Trigger an immediate reconnection attempt
/// 4. Sync any missed events
class AppLifecycleObserver extends ConsumerStatefulWidget {
  final Widget child;

  const AppLifecycleObserver({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<AppLifecycleObserver> createState() => _AppLifecycleObserverState();
}

class _AppLifecycleObserverState extends ConsumerState<AppLifecycleObserver>
    with WidgetsBindingObserver {
  DateTime? _backgroundedAt;
  bool _wasConnectedBeforeBackground = false;
  bool _isResuming = false;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initConnectivity();
  }

  void _initConnectivity() {
    // Monitor connectivity changes
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) {
        _handleConnectivityChange(result);
      },
    );
  }

  void _handleConnectivityChange(ConnectivityResult result) {
    if (kDebugMode) {
      debugPrint('[AppLifecycle] Connectivity changed: $result');
    }

    if (result == ConnectivityResult.none) {
      // Network disconnected - connection will likely drop
      if (kDebugMode) {
        debugPrint('[AppLifecycle] Network disconnected');
      }
    } else {
      // Network restored - trigger reconnection check if we were connected before
      if (_wasConnectedBeforeBackground && mounted) {
        final serverConnection = ref.read(serverConnectionProvider);
        if (!serverConnection.isConnected) {
          if (kDebugMode) {
            debugPrint('[AppLifecycle] Network restored, triggering reconnect');
          }
          _verifyAndReconnect(serverConnection, ref.read(chatControllerProvider.notifier));
        }
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final serverConnection = ref.read(serverConnectionProvider);
    final chatController = ref.read(chatControllerProvider.notifier);

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        // Hidden state (iOS) - treat similar to paused
        _handleBackgrounded(serverConnection, chatController);
        break;

      case AppLifecycleState.resumed:
        _handleResumed(serverConnection, chatController);
        break;

      case AppLifecycleState.detached:
        // App is being terminated, disconnect properly
        _handleDetached();
        break;
    }
  }

  void _handleBackgrounded(serverConnection, chatController) {
    if (kDebugMode) {
      debugPrint('[AppLifecycle] App backgrounded');
    }

    _backgroundedAt = DateTime.now();
    _wasConnectedBeforeBackground = serverConnection.isConnected;

    // Notify SSE service to pause keep-alive pings
    _notifySseServiceBackgrounded();

    // Notify notification service that app is backgrounded
    NotificationService().onAppBackgrounded();

    // Note: We don't disconnect immediately here because the SSE service
    // has its own reconnection logic. However, we mark that we're backgrounded
    // so we can handle reconnection properly when we resume.
  }

  void _handleResumed(serverConnection, chatController) async {
    if (kDebugMode) {
      debugPrint('[AppLifecycle] App resumed');
    }

    // Notify notification service that app is back in foreground
    NotificationService().onAppResumed();

    // Prevent concurrent reconnection attempts
    if (_isResuming) {
      if (kDebugMode) {
        debugPrint('[AppLifecycle] Already resuming, skipping duplicate');
      }
      return;
    }

    _isResuming = true;

    try {
      // Notify SSE service that app is back in foreground
      _notifySseServiceResumed();

      if (!_wasConnectedBeforeBackground) {
        // We weren't connected before backgrounding, nothing to restore
        _isResuming = false;
        return;
      }

      final backgroundDuration = _backgroundedAt != null
          ? DateTime.now().difference(_backgroundedAt!)
          : null;

      if (kDebugMode) {
        debugPrint('[AppLifecycle] Background duration: ${backgroundDuration?.inSeconds}s');
      }

      // If we were backgrounded for more than 30 seconds, the connection
      // is likely stale. Trigger a reconnection check.
      if (backgroundDuration != null && backgroundDuration.inSeconds > 30) {
        if (kDebugMode) {
          debugPrint('[AppLifecycle] Long background period detected, verifying connection');
        }
        await _verifyAndReconnect(serverConnection, chatController);
      } else {
        // Short background - notify chat controller that app resumed
        // so it can reconnect to events if needed
        await chatController.handleAppResumed();
      }
    } finally {
      _isResuming = false;
      _backgroundedAt = null;
    }
  }

  void _handleDetached() {
    if (kDebugMode) {
      debugPrint('[AppLifecycle] App detached (terminating)');
    }
    _wasConnectedBeforeBackground = false;
    _backgroundedAt = null;
  }

  void _notifySseServiceBackgrounded() {
    try {
      final repository = ref.read(serverConnectionProvider.notifier).repository;
      if (repository != null) {
        // Access the SSE service through the repository
        repository.notifyBackgrounded();
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[AppLifecycle] Could not notify SSE service: $e');
      }
    }
  }

  void _notifySseServiceResumed() {
    try {
      final repository = ref.read(serverConnectionProvider.notifier).repository;
      if (repository != null) {
        repository.notifyResumed();
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[AppLifecycle] Could not notify SSE service: $e');
      }
    }
  }

  Future<void> _verifyAndReconnect(serverConnection, chatController) async {
    // Clear any error state first
    chatController.clearError();

    // Use the server connection provider to verify and reconnect
    final connectionNotifier = ref.read(serverConnectionProvider.notifier);
    final reconnected = await connectionNotifier.verifyAndReconnect();

    if (reconnected) {
      if (kDebugMode) {
        debugPrint('[AppLifecycle] Reconnection successful, reconnecting to chat events');
      }
      // Reconnect to chat events through the controller
      chatController.reconnectToEvents();
    } else {
      if (kDebugMode) {
        debugPrint('[AppLifecycle] Reconnection failed');
      }
      // Connection failed - the UI will show the error state
      // User will need to manually reconnect
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
