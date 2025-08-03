import 'package:flutter/material.dart';

class CircleBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.grey.withOpacity(0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 30;

    canvas.drawCircle(center, radius, paint);

    final innerPaint =
        Paint()
          ..color = Colors.transparent
          ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 40, innerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
