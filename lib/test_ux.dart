import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() => runApp(const MaterialApp(home: BlinkPainterDemo()));

class BlinkPainterDemo extends StatefulWidget {
  const BlinkPainterDemo({super.key});

  @override
  State<BlinkPainterDemo> createState() => _BlinkPainterDemoState();
}

class _BlinkPainterDemoState extends State<BlinkPainterDemo> {
  final List<BlinkShape> _shapes = [];
  Timer? _drawTimer;
  final Random _random = Random();

  void _startDrawing(Color color) {
    _drawTimer = Timer.periodic(const Duration(milliseconds: 40), (_) {
      final position = Offset(
        _random.nextDouble() * MediaQuery.of(context).size.width,
        _random.nextDouble() * MediaQuery.of(context).size.height,
      );
      final size = _random.nextDouble() * 28 + 16;

      setState(() {
        _shapes.add(
          BlinkShape(
            position,
            size,
            color,
            rotation: _random.nextDouble() * pi * 2,
            scale: _random.nextDouble() * 0.6 + 0.7,
          ),
        );
      });
    });
  }

  void _stopDrawing() {
    _drawTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CustomPaint(
            painter: BlinkCanvasPainter(_shapes),
            size: Size.infinite,
          ),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Wrap(
              spacing: 12,
              children: [
                _buildColorButton(Colors.pinkAccent),
                _buildColorButton(Colors.blueAccent),
                _buildColorButton(Colors.yellowAccent),
                _buildColorButton(Colors.greenAccent),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorButton(Color color) {
    return GestureDetector(
      onTapDown: (_) => _startDrawing(color),
      onTapUp: (_) => _stopDrawing(),
      onTapCancel: () => _stopDrawing(),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.6),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
    );
  }
}

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
    this.rotation = 0,
    this.scale = 1,
  });
}

class BlinkCanvasPainter extends CustomPainter {
  final List<BlinkShape> shapes;
  final TextPainter _textPainter = TextPainter(
    textDirection: TextDirection.ltr,
  );

  BlinkCanvasPainter(this.shapes);

  @override
  void paint(Canvas canvas, Size size) {
    for (var shape in shapes) {
      final textSpan = TextSpan(
        text: String.fromCharCode(FontAwesomeIcons.seedling.codePoint),
        style: TextStyle(
          fontSize: shape.size * shape.scale,
          fontFamily: FontAwesomeIcons.seedling.fontFamily,
          package: FontAwesomeIcons.seedling.fontPackage,
          color: shape.color,
        ),
      );

      _textPainter.text = textSpan;
      _textPainter.layout();

      canvas.save();
      canvas.translate(shape.position.dx, shape.position.dy);
      canvas.rotate(shape.rotation);
      _textPainter.paint(
        canvas,
        Offset(-_textPainter.width / 2, -_textPainter.height / 2),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
