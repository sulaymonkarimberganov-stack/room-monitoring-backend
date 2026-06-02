import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'api_service.dart';

// Top-level function for background message handling
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background message received: ${message.messageId}');
  debugPrint('Title: ${message.notification?.title}');
  debugPrint('Body: ${message.notification?.body}');
  debugPrint('Data: ${message.data}');
}

class FCMService {
  static final FCMService _instance = FCMService._internal();
  factory FCMService() => _instance;
  FCMService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  
  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  // Navigation callback
  Function(String route, Map<String, dynamic>? data)? onNotificationTap;

  /// Initialize FCM and local notifications
  Future<void> initialize() async {
    // Request permission
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint('FCM Permission status: ${settings.authorizationStatus}');

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Get FCM token
      _fcmToken = await _firebaseMessaging.getToken();
      debugPrint('FCM Token: $_fcmToken');

      // Send token to server
      if (_fcmToken != null) {
        await _sendTokenToServer(_fcmToken!);
      }

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Listen to token refresh
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        _fcmToken = newToken;
        _sendTokenToServer(newToken);
      });

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle notification tap when app is in background
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

      // Check if app was opened from a notification
      RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        _handleNotificationTap(initialMessage);
      }

      // Set background message handler
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    } else {
      debugPrint('FCM Permission denied');
    }
  }

  /// Initialize local notifications for foreground display
  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onLocalNotificationTap,
    );

    // Create notification channel for Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'room_monitoring_channel',
      'Room Monitoring Notifications',
      description: 'Xonalar monitoring tizimi bildirshnomalari',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Send FCM token to server
  Future<void> _sendTokenToServer(String token) async {
    try {
      final api = ApiService();
      await api.sendFCMToken(token);
      debugPrint('FCM token sent to server successfully');
    } catch (e) {
      debugPrint('Error sending FCM token to server: $e');
    }
  }

  /// Handle foreground messages
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint('Foreground message received: ${message.messageId}');
    
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null) {
      // Show local notification
      await _showLocalNotification(
        title: notification.title ?? 'Yangi bildirishnoma',
        body: notification.body ?? '',
        payload: jsonEncode(message.data),
      );
    }
  }

  /// Show local notification
  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'room_monitoring_channel',
      'Room Monitoring Notifications',
      channelDescription: 'Xonalar monitoring tizimi bildirshnomalari',
      importance: Importance.high,
      priority: Priority.high,
      color: Color(0xFF1565C0),
      playSound: true,
      enableVibration: true,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: payload,
    );
  }

  /// Handle notification tap (from background/terminated)
  void _handleNotificationTap(RemoteMessage message) {
    debugPrint('Notification tapped: ${message.data}');
    _navigateBasedOnData(message.data);
  }

  /// Handle local notification tap (from foreground)
  void _onLocalNotificationTap(NotificationResponse response) {
    debugPrint('Local notification tapped: ${response.payload}');
    if (response.payload != null) {
      try {
        final data = jsonDecode(response.payload!);
        _navigateBasedOnData(data);
      } catch (e) {
        debugPrint('Error parsing notification payload: $e');
      }
    }
  }

  /// Navigate to appropriate screen based on notification data
  void _navigateBasedOnData(Map<String, dynamic> data) {
    final type = data['type'] as String?;
    
    switch (type) {
      case 'NEW_TASK':
        // Navigate to cleaner dashboard
        onNotificationTap?.call('/cleaner-dashboard', data);
        break;
      
      case 'TASK_COMPLETED':
        // Navigate to manager approval screen
        onNotificationTap?.call('/manager-dashboard', data);
        break;
      
      case 'LOW_STOCK':
        // Navigate to inventory screen
        onNotificationTap?.call('/inventory', data);
        break;
      
      case 'NEW_USER':
        // Navigate to admin dashboard
        onNotificationTap?.call('/admin-dashboard', data);
        break;
      
      default:
        // Navigate to home
        onNotificationTap?.call('/', data);
    }
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      debugPrint('Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('Error subscribing to topic: $e');
    }
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      debugPrint('Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('Error unsubscribing from topic: $e');
    }
  }

  /// Subscribe to role-based topics
  Future<void> subscribeToRoleTopics(String role) async {
    // Subscribe to role-specific topic
    await subscribeToTopic('role_${role.toLowerCase()}');
    
    // Subscribe to all users topic
    await subscribeToTopic('all_users');
  }

  /// Unsubscribe from all topics
  Future<void> unsubscribeFromAllTopics() async {
    await unsubscribeFromTopic('role_admin');
    await unsubscribeFromTopic('role_manager');
    await unsubscribeFromTopic('role_cleaner');
    await unsubscribeFromTopic('all_users');
  }
}
