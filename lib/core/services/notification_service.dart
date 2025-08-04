import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNoti =
      FlutterLocalNotificationsPlugin();

  static Future<void> initLocalNotification() async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings settings = InitializationSettings(
      android: androidInit,
    );

    await _localNoti.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          print('[Notification Clicked] Payload: ${response.payload}'); //ai chuan
          
          // TODO: Điều hướng đến trang cụ thể nếu cần
        }
      },
    );
  }

  static Future<void> showForegroundNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'default_channel', // ID
          'Default Channel', // Tên kênh
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _localNoti.show(
      message.notification.hashCode,
      message.notification?.title ?? 'Thông báo',
      message.notification?.body ?? '',
      details,
      payload: message.data['some_key'], // để xử lý khi click vào noti
    );
  }

  static void setupOnMessageListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('[onMessage] Received a message in foreground');
      showForegroundNotification(message);
    });
  }

  static void setupOnMessageOpenedAppListener() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('[onMessageOpenedApp] User clicked on notification');
      // TODO: Xử lý điều hướng từ message.data nếu cần
    });
  }
}
