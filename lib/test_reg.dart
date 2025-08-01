import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:moodsic/features/auth/pages/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // đảm bảo binding trước khi chạy async
  await Firebase.initializeApp(); // khởi tạo Firebase

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Register Demo',
      home: const RegisterPage(),
    );
  }
}
