import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

/// Service for managing local notifications when chat responses are completed.
/// Notifications are only shown when the app is in the background.
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;
  bool _isInBackground = false;
  bool _permissionsGranted = false;
  int _notificationId = 0;

  /// Whether the app is currently in the background
  bool get isInBackground => _isInBackground;

  /// Whether notification permissions have been granted
  bool get permissionsGranted => _permissionsGranted;

  /// Initialize the notification service
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Android initialization settings
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    // Don't request permissions at init - we'll request them after server connection
    final darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      notificationCategories: [
        DarwinNotificationCategory(
          'chat_complete_category',
          actions: <DarwinNotificationAction>[
            DarwinNotificationAction.plain(
              'open_action',
              'Open',
              options: <DarwinNotificationActionOption>{
                DarwinNotificationActionOption.foreground,
              },
            ),
          ],
          options: <DarwinNotificationCategoryOption>{
            DarwinNotificationCategoryOption.allowAnnouncement,
          },
        ),
      ],
      onDidReceiveLocalNotification: (id, title, body, payload) {
        // Legacy iOS callback (for iOS < 10)
        if (kDebugMode) {
          debugPrint('[NotificationService] Received local notification: $title');
        }
      },
    );

    final initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    // Initialize the plugin
    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _handleNotificationResponse,
    );

    _isInitialized = true;

    if (kDebugMode) {
      debugPrint('[NotificationService] Initialized');
    }
  }

  /// Request notification permissions from the user
  /// On Android 13+ (API 33+), this requests POST_NOTIFICATIONS permission
  Future<bool> requestPermissions() async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      // Android 13+ (API 33+) requires runtime notification permission
      if (Platform.isAndroid) {
        final status = await Permission.notification.status;
        if (kDebugMode) {
          debugPrint('[NotificationService] Android notification permission status: $status');
        }

        if (status.isDenied || status.isRestricted || status.isLimited) {
          final result = await Permission.notification.request();
          _permissionsGranted = result.isGranted;
          if (kDebugMode) {
            debugPrint('[NotificationService] Android notification permission result: $result');
          }
          return _permissionsGranted;
        } else if (status.isGranted) {
          _permissionsGranted = true;
          return true;
        }
        return false;
      }

      // Request iOS permissions - only if not already granted
      if (!_permissionsGranted) {
        final iOSResult = await _notificationsPlugin
            .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            );

        _permissionsGranted = iOSResult ?? false;

        if (kDebugMode) {
          debugPrint('[NotificationService] iOS permissions granted: $_permissionsGranted');
        }
      }

      return _permissionsGranted;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[NotificationService] Error requesting permissions: $e');
      }
      return false;
    }
  }

  /// Check if notification permissions are granted without requesting
  Future<bool> checkPermissions() async {
    try {
      if (Platform.isAndroid) {
        final status = await Permission.notification.status;
        _permissionsGranted = status.isGranted;
        if (kDebugMode) {
          debugPrint('[NotificationService] Permission check - Android: $_permissionsGranted');
        }
        return _permissionsGranted;
      }

      // For iOS, use permission_handler to check actual status
      if (Platform.isIOS) {
        final status = await Permission.notification.status;
        _permissionsGranted = status.isGranted;
        if (kDebugMode) {
          debugPrint('[NotificationService] Permission check - iOS: $_permissionsGranted (status: $status)');
        }
        return _permissionsGranted;
      }

      // Fallback for other platforms
      _permissionsGranted = true;
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[NotificationService] Error checking permissions: $e');
      }
      return false;
    }
  }

  /// Called when the app goes to background
  void onAppBackgrounded() {
    _isInBackground = true;
    if (kDebugMode) {
      debugPrint('[NotificationService] App backgrounded, notifications enabled');
    }
  }

  /// Called when the app returns to foreground
  void onAppResumed() {
    _isInBackground = false;
    if (kDebugMode) {
      debugPrint('[NotificationService] App resumed, notifications disabled');
    }
  }

  /// Show a notification when a chat response is completed.
  /// Only shows if the app is in the background and permissions are granted.
  Future<void> showChatCompleteNotification({
    required String conversationId,
    String? messagePreview,
    String? title,
  }) async {
    if (kDebugMode) {
      debugPrint('[NotificationService] Attempting to show notification');
      debugPrint('[NotificationService]   - isInBackground: $_isInBackground');
      debugPrint('[NotificationService]   - permissionsGranted: $_permissionsGranted');
      debugPrint('[NotificationService]   - isInitialized: $_isInitialized');
    }

    // Don't show notifications when app is in foreground
    if (!_isInBackground) {
      if (kDebugMode) {
        debugPrint('[NotificationService] App in foreground, skipping notification');
      }
      return;
    }

    // Check permissions before showing
    if (!_permissionsGranted) {
      // Try to check current permission status
      final hasPermission = await checkPermissions();
      if (!hasPermission) {
        if (kDebugMode) {
          debugPrint('[NotificationService] No notification permission, skipping notification');
        }
        return;
      }
    }

    if (!_isInitialized) {
      await initialize();
    }

    // Create Android notification channel
    const androidChannel = AndroidNotificationChannel(
      'chat_complete_channel',
      'Chat Complete',
      description: 'Notifications when AI chat responses are completed',
      importance: Importance.high,
    );

    // Create the channel on Android
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    // Truncate message preview if too long
    final preview = messagePreview != null && messagePreview.length > 100
        ? '${messagePreview.substring(0, 100)}...'
        : messagePreview;

    // Android notification details
    const androidDetails = AndroidNotificationDetails(
      'chat_complete_channel',
      'Chat Complete',
      channelDescription: 'Notifications when AI chat responses are completed',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
    );

    // iOS notification details
    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    final notificationTitle = title ?? 'Omni Code';
    final notificationBody = preview ?? 'New response received';

    try {
      await _notificationsPlugin.show(
        _notificationId++,
        notificationTitle,
        notificationBody,
        notificationDetails,
        payload: conversationId,
      );

      if (kDebugMode) {
        debugPrint('[NotificationService] Notification shown successfully: $notificationTitle - $notificationBody');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[NotificationService] Error showing notification: $e');
      }
    }
  }

  /// Handle notification tap
  void _handleNotificationResponse(NotificationResponse response) {
    final payload = response.payload;

    if (kDebugMode) {
      debugPrint('[NotificationService] Notification tapped, payload: $payload');
    }

    // The app will be brought to foreground automatically
    // Additional navigation logic can be added here if needed
  }

  /// Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }
}
