import 'package:flutter/material.dart';
import 'package:moodsic/shared/states/auth_provider.dart';
import 'package:moodsic/features/auth/pages/login.dart';
import 'package:moodsic/features/main_navigation/nav_bar_admin.dart';
import 'package:provider/provider.dart';

class AuthRouter extends StatelessWidget {
  const AuthRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<CAuthProvider>(context);

    if (auth.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final user = auth.user;
    final role = auth.role;

    print("[Role] $role");
    print("[User] $user");

    if (user == null) {
      return const LoginPage();
    } else if (role == 'admin') {
      return const AdminNavigationPage();
    } else {
      return const AdminNavigationPage(); // Có thể thay bằng trang khác cho user thường
    }
  }
}
