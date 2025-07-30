import 'package:flutter/material.dart';

class BlinkShape {
  final Offset position;
  final double size;
  final Color color;
  final double rotation;
  final double scale;

  BlinkShape(
    this.position,
    this.size,
    this.color, {
    this.rotation = 0.0,
    this.scale = 1.0,
  });
}

class BlinkCanvasPainter extends CustomPainter {
  final List<BlinkShape> shapes;

  BlinkCanvasPainter(this.shapes);

  @override
  void paint(Canvas canvas, Size size) {
    for (var shape in shapes) {
      final paint =
          Paint()
            ..color = shape.color.withOpacity(0.8)
            ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(shape.position.dx, shape.position.dy);
      canvas.rotate(shape.rotation);
      canvas.scale(shape.scale);

      final path =
          Path()
            ..moveTo(0, -shape.size)
            ..quadraticBezierTo(shape.size * 0.4, 0, 0, shape.size)
            ..quadraticBezierTo(-shape.size * 0.4, 0, 0, -shape.size)
            ..close();

      canvas.drawPath(path, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
