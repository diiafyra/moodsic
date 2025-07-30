import 'package:flutter/material.dart';

class OverlayLayer extends StatelessWidget {
  final Color color;
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const OverlayLayer({
    super.key,
    required this.color,
    this.width = double.infinity,
    this.height = double.infinity,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: color, borderRadius: borderRadius),
    );
  }
}
