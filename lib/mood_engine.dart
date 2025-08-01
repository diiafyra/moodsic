import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:moodsic/core/config/theme/app_colors.dart';
import 'package:moodsic/core/services/clip_path.dart';

class MoodCanvasPainterWidget extends StatefulWidget {
  final Size canvasSize;
  final List<List<dynamic>> moods; // Mảng 2 chiều: [color, label, labelColor]

  const MoodCanvasPainterWidget({
    super.key,
    required this.canvasSize,
    required this.moods,
  });

  @override
  State<MoodCanvasPainterWidget> createState() =>
      _MoodCanvasPainterWidgetState();
}

class _MoodCanvasPainterWidgetState extends State<MoodCanvasPainterWidget> {
  final List<BlinkShape> _shapes = [];
  final Map<String, double> _totalPressDurations = {};
  Timer? _drawTimer;
  final Random _random = Random();
  DateTime? _currentStartTime;
  String? _currentLabel;

  void _startDrawing(Color color, String label) {
    _currentStartTime = DateTime.now();
    _currentLabel = label;

    _drawTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      final maxWidth = widget.canvasSize.width;
      final maxHeight = widget.canvasSize.height;

      final double x = _random.nextDouble() * (maxWidth);
      final double y = _random.nextDouble() * (maxHeight);
      final position = Offset(x, y);
      final size = _random.nextDouble() * 40 + 16;

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
    if (_currentStartTime != null && _currentLabel != null) {
      final endTime = DateTime.now();
      final duration =
          endTime.difference(_currentStartTime!).inMilliseconds / 1000.0;
      setState(() {
        _totalPressDurations[_currentLabel!] =
            (_totalPressDurations[_currentLabel!] ?? 0) + duration;
        debugPrint('Total Press Durations: $_totalPressDurations');
      });
      _currentStartTime = null;
      _currentLabel = null;
    }
    _drawTimer?.cancel();
  }

  void _clearCanvas() {
    setState(() {
      _shapes.clear();
      _totalPressDurations.clear();
      debugPrint('Canvas and durations cleared');
    });
  }

  void _sendData() {
    setState(() {
      debugPrint('Gửi thành công: $_totalPressDurations');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: widget.canvasSize.width,
          height: widget.canvasSize.height,
          decoration: BoxDecoration(
            color: AppColors.indigoNight950,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CustomPaint(
              painter: BlinkCanvasPainter(_shapes),
              size: widget.canvasSize,
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 250,
          height: 250,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Vẽ vòng tròn thủng lỗ làm nền
              CustomPaint(
                painter: CircleBackgroundPainter(),
                size: const Size(200, 200),
              ),
              // 4 nút mood là 1/4 vòng tròn
              if (widget.moods.length > 0)
                Positioned(
                  top: 25,
                  left: 25,
                  child: _buildColorButton(
                    widget.moods[0][0],
                    widget.moods[0][1],
                    widget.moods[0][2],
                    QuarterCircleCorner.topLeft,
                  ),
                ),
              if (widget.moods.length > 1)
                Positioned(
                  bottom: 25,
                  left: 25,
                  child: _buildColorButton(
                    widget.moods[1][0],
                    widget.moods[1][1],
                    widget.moods[1][2],
                    QuarterCircleCorner.bottomLeft,
                  ),
                ),
              if (widget.moods.length > 2)
                Positioned(
                  top: 25,
                  right: 25,
                  child: _buildColorButton(
                    widget.moods[2][0],
                    widget.moods[2][1],
                    widget.moods[2][2],
                    QuarterCircleCorner.topRight,
                  ),
                ),
              if (widget.moods.length > 3)
                Positioned(
                  bottom: 25,
                  right: 25,
                  child: _buildColorButton(
                    widget.moods[3][0],
                    widget.moods[3][1],
                    widget.moods[3][2],
                    QuarterCircleCorner.bottomRight,
                  ),
                ),
              // Nút Gửi ở giữa
              if (widget.moods.length > 0) _buildSendButton(),
              // Nút Xóa ở trên phải, hình vuông với radius
              Positioned(top: 0, right: 0, child: _buildClearButton()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildColorButton(
    Color color,
    String label,
    Color labelColor,
    QuarterCircleCorner corner,
  ) {
    return GestureDetector(
      onTapDown: (_) => _startDrawing(color, label),
      onTapUp: (_) => _stopDrawing(),
      onTapCancel: () => _stopDrawing(),
      child: ClipPath(
        clipper: QuarterCircleClipper(corner: corner),
        child: Container(
          width: 100,
          height: 100,
          color: color,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: labelColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                shadows: const [
                  Shadow(
                    color: Colors.black54,
                    offset: Offset(1, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    return GestureDetector(
      onTap: _sendData,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.oceanBlue800,
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Text(
            'Gửi',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.black54,
                  offset: Offset(1, 1),
                  blurRadius: 2,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildClearButton() {
    return GestureDetector(
      onTap: _clearCanvas,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.brickRed600,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            'Xóa',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.black54,
                  offset: Offset(1, 1),
                  blurRadius: 2,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

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
