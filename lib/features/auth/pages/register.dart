// features/auth/screens/register_page.dart
import 'package:flutter/material.dart';
import '../widgets/register_form.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF1F4C5B),
      body: Center(child: SingleChildScrollView(child: RegisterForm())),
    );
  }
}
