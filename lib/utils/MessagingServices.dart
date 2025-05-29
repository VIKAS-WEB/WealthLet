import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    try {
      // Request permission for iOS
      await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      // Get FCM token
      String? token = await _firebaseMessaging.getToken();
      print("FCM Token: $token");

      // Initialize local notifications
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      // const IOSInitializationSettings iosSettings = IOSInitializationSettings(
      //   requestAlertPermission: true,
      //   requestBadgePermission: true,
      //   requestSoundPermission: true,
      // );
      const InitializationSettings initSettings =
          InitializationSettings(android: androidSettings);

      // Ensure platform-specific implementation exists
      bool? initialized = await _notificationsPlugin.initialize(initSettings);
      if (initialized == null || !initialized) {
        print("Failed to initialize flutter_local_notifications");
        return;
      }

      // Create notification channel for Android
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'wealthlet_channel',
        'Wealthlet Notifications',
        description: 'Notifications for Wealthlet app',
        importance: Importance.max,
      );
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      // Handle foreground notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        if (notification != null && android != null) {
          _notificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                importance: Importance.max,
                priority: Priority.high,
              ),
            ),
          );
        }
      });

      // Handle background notifications
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print("Notification opened: ${message.notification?.title}");
        if (message.data['screen'] == 'dashboard') {
          print("Navigating to dashboard");
        }
      });
    } catch (e) {
      print("Error initializing MessagingService: $e");
    }
  }

  Future<void> saveFcmTokenForUser(String userId) async {
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        await FirebaseFirestore.instance.collection('users').doc(userId).set(
          {'fcmToken': token},
          SetOptions(merge: true),
        );
        print("FCM Token saved for user $userId: $token");
      } else {
        print("Failed to get FCM token for user $userId");
      }
    } catch (e) {
      print("Error saving FCM token: $e");
    }
  }
}
