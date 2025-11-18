
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// // import 'package:flutter/material.dart';

// class NotificationService {
//   NotificationService._();
//   static final NotificationService instance = NotificationService._();

//   final FlutterLocalNotificationsPlugin _fln = FlutterLocalNotificationsPlugin();
//   final FirebaseMessaging _fm = FirebaseMessaging.instance;

//   Future<void> init() async {
//     // timezone init for scheduled notifications (optional)
//     tz.initializeTimeZones();
//     tz.setLocalLocation(tz.getLocation(tz.local.name));

//     const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
//     final iosInit = DarwinInitializationSettings();
//     await _fln.initialize(
//       InitializationSettings(android: androidInit, iOS: iosInit),
//       onDidReceiveNotificationResponse: (payload) {
//         // handle tap when app is foreground/background
//       },
//     );

//     // Request permissions (iOS & Android 13+)
//     await requestPermission();

//     // Handlers
//     FirebaseMessaging.onMessage.listen(_onMessageHandler);
//     FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

//     // Optional: check for initial message if app opened from terminated state
//     final initialMessage = await _fm.getInitialMessage();
//     if (initialMessage != null) {
//       // handle deep link / navigation
//       print('App opened from terminated state by message: ${initialMessage.data}');
//     }
//   }

//   Future<void> requestPermission() async {
//     NotificationSettings settings = await _fm.requestPermission(
//       alert: true, badge: true, sound: true, provisional: false,
//     );
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('notif_opt_in', settings.authorizationStatus == AuthorizationStatus.authorized);
//     print('Notification authorization: ${settings.authorizationStatus}');
//   }

//   Future<String?> getToken() => _fm.getToken();

//   void _onMessageHandler(RemoteMessage message) {
//     // Show local notification when app in foreground
//     final n = message.notification;
//     if (n != null) {
//       final androidDetails = AndroidNotificationDetails(
//         'default_channel',
//         'Default',
//         channelDescription: 'Default channel',
//         importance: Importance.max,
//         priority: Priority.high,
//       );
//       _fln.show(n.hashCode, n.title, n.body, NotificationDetails(android: androidDetails));
//     }
//   }

//   void _onMessageOpenedApp(RemoteMessage message) {
//     print('User tapped notification: ${message.data}');
//     // navigate to desired screen
//   }

//   // Call when user logs out or you want to remove token from server
//   Future<void> deleteToken() => _fm.deleteToken();
// }

// notification_service.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _fln = FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _fm = FirebaseMessaging.instance;

  Future<void> init() async {
    // timezone init for scheduled notifications (optional)
    tz.initializeTimeZones();
    try {
      tz.setLocalLocation(tz.getLocation(tz.local.name));
    } catch (_) {
      // fallback if tz.local isn't resolvable
    }

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iosInit = DarwinInitializationSettings();
    await _fln.initialize(
      InitializationSettings(android: androidInit, iOS: iosInit),
      onDidReceiveNotificationResponse: (payload) {
        // handle tap when app is foreground/background
      },
    );

    // NOTE: we removed the automatic permission prompt from init()
    // so the app can request permission later from the UI.

    // Handlers
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    // Optional: check for initial message if app opened from terminated state
    final initialMessage = await _fm.getInitialMessage();
    if (initialMessage != null) {
      // handle deep link / navigation
      print('App opened from terminated state by message: ${initialMessage.data}');
    }
  }

  Future<void> requestPermission() async {
    NotificationSettings settings = await _fm.requestPermission(
      alert: true, badge: true, sound: true, provisional: false,
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notif_opt_in', settings.authorizationStatus == AuthorizationStatus.authorized);
    print('Notification authorization: ${settings.authorizationStatus}');
    return;
  }

  Future<String?> getToken() => _fm.getToken();

  void _onMessageHandler(RemoteMessage message) {
    final n = message.notification;
    if (n != null) {
      final androidDetails = AndroidNotificationDetails(
        'default_channel',
        'Default',
        channelDescription: 'Default channel',
        importance: Importance.max,
        priority: Priority.high,
      );
      _fln.show(n.hashCode, n.title, n.body, NotificationDetails(android: androidDetails));
    }
  }

  void _onMessageOpenedApp(RemoteMessage message) {
    print('User tapped notification: ${message.data}');
    // navigate to desired screen
  }

  // Call when user logs out or you want to remove token from server
  Future<void> deleteToken() => _fm.deleteToken();
}
