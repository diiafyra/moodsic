import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moodsic/features/survey/pages/connect_spotify_page.dart';
import 'package:moodsic/shared/states/auth_provider.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<void> register(String email, String password, String username) async {
    try {
      CAuthProvider.instance.setAuthenticating(true);

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user?.updateDisplayName(username);

      await CAuthProvider.instance.refreshUserState();
    } on FirebaseAuthException catch (e) {
      CAuthProvider.instance.setAuthenticating(false);

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
      CAuthProvider.instance.setAuthenticating(true);

      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await CAuthProvider.instance.refreshUserState();

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      CAuthProvider.instance.setAuthenticating(false);

      if (e.code == 'user-not-found') {
        throw Exception("Không tìm thấy tài khoản với email này.");
      } else if (e.code == 'wrong-password') {
        throw Exception("Sai mật khẩu.");
      } else {
        throw Exception("Lỗi đăng nhập: ${e.message}");
      }
    }
  }
}
