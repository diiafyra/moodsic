import 'package:flutter/material.dart';
import 'package:moodsic/features/auth/widgets/login_form.dart';

class LoginPage extends StatefulWidget {
  final bool showRegisterSuccess;

  const LoginPage({super.key, this.showRegisterSuccess = false});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.showRegisterSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Đăng ký thành công, hãy đăng nhập")),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF1F4C5B),
      body: SafeArea(child: Center(child: LoginForm())),
    );
  }
}
