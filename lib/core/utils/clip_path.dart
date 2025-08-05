import 'dart:math' as math;
import 'package:flutter/material.dart';

enum QuarterCircleCorner { topLeft, topRight, bottomLeft, bottomRight }

class QuarterCircleClipper extends CustomClipper<Path> {
  final QuarterCircleCorner corner;

  QuarterCircleClipper({required this.corner});

  @override
  Path getClip(Size size) {
    final radius = math.min(size.width, size.height);

    // Mỗi góc có center riêng và startAngle riêng
    late Offset center;
    late double startAngle;

    switch (corner) {
      case QuarterCircleCorner.topLeft:
        center = Offset(radius, radius);
        startAngle = math.pi; // 180°
        break;
      case QuarterCircleCorner.topRight:
        center = Offset(size.width - radius, radius);
        startAngle = -math.pi / 2; // -90°
        break;
      case QuarterCircleCorner.bottomRight:
        center = Offset(size.width - radius, size.height - radius);
        startAngle = 0; // 0°
        break;
      case QuarterCircleCorner.bottomLeft:
        center = Offset(radius, size.height - radius);
        startAngle = math.pi / 2; // 90°
        break;
    }

    final rect = Rect.fromCircle(center: center, radius: radius);

    final path = Path();
    path.moveTo(center.dx, center.dy);
    path.arcTo(rect, startAngle, math.pi / 2, false);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant QuarterCircleClipper oldClipper) {
    return oldClipper.corner != corner;
  }
}
