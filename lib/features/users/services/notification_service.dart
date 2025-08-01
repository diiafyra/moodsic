import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static Future<String?> sendNotificationToUser({
    required String targetUserId,
    required String message,
    required String recipientType,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return 'Admin not authenticated';
    }

    final trimmedMessage = message.trim();
    if (trimmedMessage.isEmpty) {
      return 'Please enter a message';
    }

    try {
      final callable = FirebaseFunctions.instance.httpsCallable(
        'sendNotifications',
      );

      print('[NotificationService] Calling Cloud Function...');
      await callable.call({
        'userId': targetUserId,
        'senderId': currentUser.uid,
        'message': trimmedMessage,
        'recipientType': recipientType,
      });

      print('[NotificationService] Notification sent successfully');
      return null; // no error
    } on FirebaseFunctionsException catch (e) {
      print('[NotificationService] FirebaseFunctionsException: ${e.message}');
      return 'Error sending notification: ${e.message}';
    } catch (e) {
      print('[NotificationService] Unknown error: $e');
      return 'Error sending notification: $e';
    }
  }
}
