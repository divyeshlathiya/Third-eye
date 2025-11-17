import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Ensure Firebase is initialized (required if you use Firebase APIs here)
  await Firebase.initializeApp();
  // Handle background message (log or show local notification if desired)
  debugPrint('Background message received: ${message.messageId}, data: ${message.data}');
}
