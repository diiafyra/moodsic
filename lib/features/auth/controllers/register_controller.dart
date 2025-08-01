// features/auth/controllers/register_controller.dart
import 'package:flutter/material.dart';
import 'package:moodsic/features/auth/pages/login.dart';
import 'package:moodsic/features/auth/services/auth_service.dart';

class RegisterController {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool acceptedPolicy = false;

  final AuthService _authService = AuthService();

  void togglePrivacy(bool? value) {
    acceptedPolicy = value ?? false;
  }

  Future<void> onRegister(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;
    if (!acceptedPolicy) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng chấp nhận điều khoản.")),
      );
      return;
    }

    try {
      await _authService.register(
        emailController.text.trim(),
        passwordController.text,
        usernameController.text.trim(),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
