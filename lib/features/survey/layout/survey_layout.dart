import 'package:flutter/material.dart';

class SurveyLayout extends StatelessWidget {
  final Widget middleWidget;

  const SurveyLayout({super.key, required this.middleWidget});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Text(
            "Welcome to Moodsic 🎵",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          /// 👇 Nhúng widget vào layout chính
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: middleWidget,
            ),
          ),
          const SizedBox(height: 16),
          const Icon(Icons.arrow_downward_rounded, size: 32),
          const SizedBox(height: 8),
          const Icon(Icons.arrow_downward_rounded, size: 28),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
