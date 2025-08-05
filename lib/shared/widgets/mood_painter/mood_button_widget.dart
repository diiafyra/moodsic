import 'package:flutter/material.dart';
import 'package:moodsic/core/config/theme/app_colors.dart';
import 'package:moodsic/core/utils/clip_path.dart';
import 'circle_background_painter.dart';

class MoodButtonsWidget extends StatelessWidget {
  final List<List<dynamic>> moods;
  final Function(Color, String) onStartDrawing;
  final VoidCallback onStopDrawing;
  final VoidCallback onSend;
  final VoidCallback onClear;

  const MoodButtonsWidget({
    super.key,
    required this.moods,
    required this.onStartDrawing,
    required this.onStopDrawing,
    required this.onSend,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 250,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            painter: CircleBackgroundPainter(),
            size: const Size(200, 200),
          ),
          if (moods.isNotEmpty)
            Positioned(
              top: 25,
              left: 25,
              child: _buildColorButton(
                moods[0][0],
                moods[0][1],
                moods[0][2],
                QuarterCircleCorner.topLeft,
              ),
            ),
          if (moods.length > 1)
            Positioned(
              bottom: 25,
              left: 25,
              child: _buildColorButton(
                moods[1][0],
                moods[1][1],
                moods[1][2],
                QuarterCircleCorner.bottomLeft,
              ),
            ),
          if (moods.length > 2)
            Positioned(
              top: 25,
              right: 25,
              child: _buildColorButton(
                moods[2][0],
                moods[2][1],
                moods[2][2],
                QuarterCircleCorner.topRight,
              ),
            ),
          if (moods.length > 3)
            Positioned(
              bottom: 25,
              right: 25,
              child: _buildColorButton(
                moods[3][0],
                moods[3][1],
                moods[3][2],
                QuarterCircleCorner.bottomRight,
              ),
            ),
          if (moods.isNotEmpty) _buildSendButton(),
          Positioned(top: 0, right: 0, child: _buildClearButton()),
        ],
      ),
    );
  }

  Widget _buildColorButton(
    Color color,
    String label,
    Color labelColor,
    QuarterCircleCorner corner,
  ) {
    return GestureDetector(
      onTapDown: (_) => onStartDrawing(color, label),
      onTapUp: (_) => onStopDrawing(),
      onTapCancel: () => onStopDrawing(),
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
      onTap: onSend,
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
      onTap: onClear,
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
