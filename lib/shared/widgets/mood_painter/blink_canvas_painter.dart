import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:moodsic/core/config/theme/app_colors.dart';
import 'package:moodsic/shared/widgets/mood_painter/mood_shape.dart';

class BlinkCanvasPainter extends CustomPainter {
  final List<BlinkShape> shapes;
  final String canvasText;
  final Size canvasSize;
  final TextPainter _textPainter = TextPainter(
    textDirection: TextDirection.ltr,
  );

  BlinkCanvasPainter(this.shapes, this.canvasText, this.canvasSize);

  @override
  void paint(Canvas canvas, Size size) {
    // Draw background
    final backgroundPaint = Paint()..color = AppColors.indigoNight950;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      backgroundPaint,
    );

    // Draw shapes
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

    // Draw text with gradient background
    if (canvasText.isNotEmpty) {
      final textSpan = TextSpan(
        text: canvasText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
      );
      _textPainter.text = textSpan;
      _textPainter.layout(maxWidth: canvasSize.width - 40);
      final textWidth = _textPainter.width;
      final textHeight = _textPainter.height;
      final textOffset = Offset(
        (canvasSize.width - textWidth) / 2,
        (canvasSize.height - textHeight) / 2,
      );

      // Draw gradient background for text
      final gradientPaint =
          Paint()
            ..shader = RadialGradient(
              center: Alignment.center,
              radius: 0.8,
              colors: [
                Colors.black.withOpacity(0.5),
                Colors.black.withOpacity(0.8),
              ],
            ).createShader(
              Rect.fromCenter(
                center: textOffset + Offset(textWidth / 2, textHeight / 2),
                width: textWidth + 16,
                height: textHeight + 16,
              ),
            );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            textOffset.dx - 8,
            textOffset.dy - 8,
            textWidth + 16,
            textHeight + 16,
          ),
          const Radius.circular(8),
        ),
        gradientPaint,
      );

      // Draw text
      _textPainter.paint(canvas, textOffset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
