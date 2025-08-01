import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static Future<void> callSendNotificationFunction({
    required String userId,
    required String senderId,
    required String message,
  }) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        print('[NotificationService] User is not authenticated');
        return;
      }
      final callable = FirebaseFunctions.instance.httpsCallable(
        'sendNotifications',
      );

      print('[NotificationService] Calling sendNotifications...');
      print(
        '[NotificationService] Params: userId=$userId, senderId=$senderId, message=$message',
      );

      final response = await callable.call({
        'userId': userId,
        'senderId': senderId,
        'message': message,
      });

      print('[NotificationService] Cloud Function response: ${response.data}');
    } on FirebaseFunctionsException catch (e) {
      print(
        '[NotificationService] FirebaseFunctionsException: ${e.code} - ${e.message}',
      );
      rethrow;
    } catch (e) {
      print('[NotificationService] Unknown error: $e');
      rethrow;
    }
  }
}
