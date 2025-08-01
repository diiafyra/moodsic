// Widget cho nút kéo lên
import 'package:flutter/material.dart';

class ScrollToTopButton extends StatelessWidget {
  final VoidCallback onTap;

  const ScrollToTopButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        child: const Center(
          child: Icon(Icons.arrow_upward, color: Colors.white, size: 32),
        ),
      ),
    );
  }
}
