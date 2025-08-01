import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double size;

  const AddButton({super.key, required this.onPressed, this.size = 28.0});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.add_circle_outline, size: size),
      color: Colors.white,
      onPressed: onPressed,
    );
  }
}
