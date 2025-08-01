import 'package:flutter/material.dart';
import 'package:moodsic/core/config/theme/app_colors.dart';
import 'package:moodsic/core/widgets/password_field.dart';
import 'package:moodsic/core/widgets/text_field.dart';
import 'package:moodsic/features/auth/controllers/register_controller.dart';
import 'package:moodsic/features/auth/pages/login.dart';
import 'package:moodsic/features/auth/widgets/social_button.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _controller = RegisterController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _controller.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Register',
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          CustomFigmaTextField(
            hintText: 'Username',
            controller: _controller.usernameController,
            isRequired: true,
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

          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: _controller.acceptedPolicy,
                  activeColor: AppColors.oceanBlue800,
                  side: const BorderSide(color: AppColors.charcoal100),
                  onChanged:
                      (val) => setState(() => _controller.togglePrivacy(val)),
                ),
                const Text(
                  "I have read the ",
                  style: TextStyle(color: Colors.white),
                ),
                GestureDetector(
                  onTap: () {}, // TODO: show privacy
                  child: const Text(
                    "Privacy Policy",
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _controller.onRegister(context),
            style: ElevatedButton.styleFrom(
              foregroundColor: AppColors.charcoal50,
              backgroundColor: const Color(0xFF4F849F),
              minimumSize: const Size(339, 48),
            ),
            child: const Text('Register'),
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            }, // TODO: Navigate to login
            child: const Text.rich(
              TextSpan(
                text: "Already have an account? ",
                children: [
                  TextSpan(
                    text: "Login",
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
