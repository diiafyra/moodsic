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
    this.rotation = 0,
    this.scale = 1,
  });
}
