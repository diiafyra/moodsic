import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:moodsic/routes/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:moodsic/core/services/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Chờ CAuthProvider khởi tạo
      future: CAuthProvider.instance.init(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Hiển thị màn hình chờ trong khi khởi tạo
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }
        // Khi khởi tạo xong, cung cấp CAuthProvider
        return ChangeNotifierProvider.value(
          value: CAuthProvider.instance,
          child: MaterialApp.router(
            routerConfig: router,
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}
