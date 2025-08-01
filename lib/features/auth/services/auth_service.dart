// features/auth/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moodsic/features/survey/pages/connect_spotify_page.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<void> register(String email, String password, String username) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user?.updateDisplayName(username);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception("Email đã được sử dụng.");
      } else if (e.code == 'weak-password') {
        throw Exception("Mật khẩu quá yếu.");
      } else {
        throw Exception("Lỗi đăng ký: ${e.message}");
      }
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception("Không tìm thấy tài khoản với email này.");
      } else if (e.code == 'wrong-password') {
        throw Exception("Sai mật khẩu.");
      } else {
        throw Exception("Lỗi đăng nhập: ${e.message}");
      }
    }
  }

  Future<void> loadUserAndNavigate(BuildContext context) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ConnectSpotifyPage()),
    );
  }
}
