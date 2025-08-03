import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:moodsic/core/config/theme/app_colors.dart';
import 'package:moodsic/data/models/playlist_model.dart';
import 'package:moodsic/shared/widgets/mood_painter/mood_button_widget.dart';
import 'blink_canvas_painter.dart';
import 'canvas_state_manager.dart';

class MoodCanvasPainterWidget extends StatefulWidget {
  final Size canvasSize;
  final List<List<dynamic>> moods; // Array of [color, label, labelColor]
  final void Function(List<PlaylistModel>) onPlaylistsReceived;

  const MoodCanvasPainterWidget({
    super.key,
    required this.canvasSize,
    required this.moods,
    required this.onPlaylistsReceived,
  });

  @override
  State<MoodCanvasPainterWidget> createState() =>
      _MoodCanvasPainterWidgetState();
}

class _MoodCanvasPainterWidgetState extends State<MoodCanvasPainterWidget> {
  late final CanvasStateManager _stateManager;

  @override
  void initState() {
    super.initState();
    _stateManager = CanvasStateManager(
      onStateChanged: () => setState(() {}),
      onShowImagePopup: _showImagePopup,
    );
  }

  // SỬA LỖI: Popup chỉ hiển thị image, không gọi API
  Future<void> _showImagePopup(ui.Image image) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Text('Canvas Image'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RawImage(image: image),
                const SizedBox(height: 16),
                const Text('Đang xử lý yêu cầu...'),
                const SizedBox(height: 8),
                const CircularProgressIndicator(),
              ],
            ),
          ),
    );

    // Đợi một chút để popup hiển thị
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // SỬA LỖI: Hàm riêng để xử lý send data
  Future<void> _handleSendData() async {
    try {
      // Gọi sendData để lấy playlists
      final playlists = await _stateManager.sendData();

      // Đóng popup loading
      if (mounted) {
        Navigator.of(context).pop();
      }

      // Truyền playlists về parent
      widget.onPlaylistsReceived(playlists);
    } catch (e) {
      debugPrint('❌ Error handling send data: $e');

      // Đóng popup nếu có lỗi
      if (mounted) {
        Navigator.of(context).pop();

        // Hiển thị error dialog
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Lỗi'),
                content: Text('Có lỗi xảy ra: $e'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: widget.canvasSize.width,
              height: widget.canvasSize.height,
              decoration: BoxDecoration(
                color: AppColors.indigoNight950,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: RepaintBoundary(
                  key: _stateManager.canvasKey,
                  child: GestureDetector(
                    onTap: _stateManager.toggleTextField,
                    child: CustomPaint(
                      painter: BlinkCanvasPainter(
                        _stateManager.shapes,
                        _stateManager.isTextFieldVisible
                            ? ''
                            : _stateManager.canvasTextController.text,
                        widget.canvasSize,
                      ),
                      size: widget.canvasSize,
                    ),
                  ),
                ),
              ),
            ),
            if (_stateManager.isTextFieldVisible)
              Positioned(
                top: widget.canvasSize.height / 2 - 30,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _stateManager.canvasTextController,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Nhập văn bản tại đây',
                      hintStyle: TextStyle(color: Colors.white54),
                    ),
                    maxLines: null,
                    onSubmitted: (_) => _stateManager.toggleTextField(),
                    onChanged: (value) => _stateManager.updateCanvas(),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 20),
        MoodButtonsWidget(
          moods: widget.moods,
          onStartDrawing:
              (color, label) =>
                  _stateManager.startDrawing(color, label, widget.canvasSize),
          onStopDrawing: _stateManager.stopDrawing,
          onSend: _handleSendData, // SỬA LỖI: Sử dụng hàm riêng
          onClear: _stateManager.clearCanvas,
        ),
      ],
    );
  }
}
