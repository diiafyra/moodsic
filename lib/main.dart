import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:moodsic/core/services/notification_service.dart';
import 'package:moodsic/routes/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:moodsic/shared/states/auth_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService.initLocalNotification();
  NotificationService.setupOnMessageListener();
  NotificationService.setupOnMessageOpenedAppListener();

  // 🔐 Kích hoạt App Check
  try {
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,
      appleProvider: AppleProvider.debug,
    );
    print('[AppCheck] App Check activated');
  } catch (e) {
    print('[AppCheck] Activation failed: $e');
  }

  // 🔒 Lấy token App Check (giúp debug)
  try {
    final token = await FirebaseAppCheck.instance.getToken();
    print('[AppCheck] Token: $token');
  } catch (e) {
    print('[AppCheck] Error getting token: $e');
  }

  // 🛑 Xin quyền thông báo (iOS cần)
  final settings = await FirebaseMessaging.instance.requestPermission();
  print('[FCM] Permission granted: ${settings.authorizationStatus}');

  // 🔁 Lắng nghe thông báo khi đang chạy
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('[FCM] Foreground: ${message.notification?.title}');
  });

  // 📬 Khi người dùng bấm vào thông báo (mở app)
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('[FCM] Opened from notification: ${message.data}');
    // TODO: Bạn có thể chuyển màn hình tại đây
  });

  // 💤 Thông báo khi app đang tắt
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('[Background FCM] Data: ${message.data}');
  if (message.notification != null) {
    print('[Background FCM] Notification: ${message.notification!.title}');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: CAuthProvider.instance.init(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        return ChangeNotifierProvider.value(
          value: CAuthProvider.instance,
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: appRouter,
          ),
        );
      },
    );
  }
}
