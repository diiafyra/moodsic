import 'package:flutter/material.dart';
import 'package:moodsic/core/config/theme/app_colors.dart';
import 'package:moodsic/core/widgets/password_field.dart';
import 'package:moodsic/core/widgets/text_field.dart';
import 'package:moodsic/features/auth/controllers/login_controller.dart';
import 'package:moodsic/features/auth/pages/register.dart';
import 'package:moodsic/features/auth/widgets/social_button.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _controller = LoginController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _controller.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Login',
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          CustomFigmaTextField(
            hintText: 'Email',
            controller: _controller.emailController,
            keyboardType: TextInputType.emailAddress,
            isRequired: true,
          ),
          const SizedBox(height: 16),
          CustomPasswordField(controller: _controller.passwordController),
          const SizedBox(height: 16),

          ElevatedButton(
            onPressed: () => _controller.onLogin(context),
            style: ElevatedButton.styleFrom(
              foregroundColor: AppColors.charcoal100,
              backgroundColor: const Color(0xFF4F849F),
              minimumSize: const Size(339, 48),
            ),
            child: const Text('Login'),
          ),
          const SizedBox(height: 32),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              children: [
                Expanded(child: Divider(color: Colors.white)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text("Or", style: TextStyle(color: Colors.white)),
                ),
                Expanded(child: Divider(color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const SocialButtons(),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RegisterPage()),
              );
            },
            child: const Text.rich(
              TextSpan(
                text: "Don't have an account? ",
                children: [
                  TextSpan(
                    text: "Register",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
