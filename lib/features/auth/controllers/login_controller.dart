import 'package:flutter/material.dart';
import 'package:moodsic/features/auth/services/auth_service.dart';
import 'package:moodsic/features/survey/pages/connect_spotify_page.dart';

class LoginController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool acceptedPolicy = false;

  final AuthService _authService = AuthService();

  void togglePrivacy(bool? value) {
    acceptedPolicy = value ?? false;
  }

  Future<void> onLogin(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    try {
      await _authService.login(
        emailController.text.trim(),
        passwordController.text,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ConnectSpotifyPage()),
      );
      // // ✅ Điều hướng sang TransitionPage sau khi login
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder:
      //         (_) => TransitionPage(
      //           loadingUI: const Text(
      //             "Đang kiểm tra tài khoản...",
      //             style: TextStyle(color: Colors.white),
      //           ),
      //           onLoad: (context) async {
      //             await _authService.loadUserAndNavigate(context);
      //           },
      //         ),
      //   ),
      // );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}
