import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:moodsic/core/services/api_service.dart';
import 'package:moodsic/data/models/playlist_model.dart';
import 'package:moodsic/shared/widgets/mood_painter/circumplex_result.dart';
import 'package:moodsic/shared/widgets/mood_painter/mood_shape.dart';

class CanvasStateManager {
  final List<BlinkShape> shapes = [];
  final Map<String, double> totalPressDurations = {};
  final TextEditingController canvasTextController = TextEditingController();
  Timer? _drawTimer;
  final Random _random = Random();
  DateTime? _currentStartTime;
  String? _currentLabel;
  final GlobalKey canvasKey = GlobalKey();
  bool isTextFieldVisible = false;
  final VoidCallback onStateChanged;
  final Future<void> Function(ui.Image) onShowImagePopup;

  CanvasStateManager({
    required this.onStateChanged,
    required this.onShowImagePopup,
  });

  void startDrawing(Color color, String label, Size canvasSize) {
    _currentStartTime = DateTime.now();
    _currentLabel = label;

    _drawTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      addShape(color, canvasSize);
      onStateChanged();
    });
  }

  void stopDrawing() {
    if (_currentStartTime != null && _currentLabel != null) {
      final endTime = DateTime.now();
      final duration =
          endTime.difference(_currentStartTime!).inMilliseconds / 1000.0;
      totalPressDurations[_currentLabel!] =
          (totalPressDurations[_currentLabel!] ?? 0) + duration;
      debugPrint('Total Press Durations: $totalPressDurations');
      _currentStartTime = null;
      _currentLabel = null;
    }
    _drawTimer?.cancel();
  }

  void clearCanvas() {
    shapes.clear();
    totalPressDurations.clear();
    canvasTextController.clear();
    isTextFieldVisible = false;
    debugPrint('Canvas and durations cleared');
    onStateChanged();
  }

  Future<ui.Image?> captureCanvas() async {
    try {
      final boundary =
          canvasKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final image = await boundary.toImage(pixelRatio: 3.0);
      return image;
    } catch (e) {
      debugPrint('Error capturing canvas: $e');
      return null;
    }
  }

  // SỬA LỖI: Tách riêng logic hiển thị popup và gọi API
  Future<List<PlaylistModel>> sendData() async {
    try {
      isTextFieldVisible = false;
      onStateChanged();

      // Capture canvas image
      final image = await captureCanvas();
      if (image == null) {
        debugPrint('❌ Failed to capture canvas image');
        return [];
      }

      // Hiển thị popup với image
      await onShowImagePopup(image);

      // Prepare data for API
      final moodText = canvasTextController.text;
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        debugPrint('❌ User not authenticated');
        return [];
      }

      final uid = user.uid;
      final valence =
          calculateCircumplex(totalPressDurations)['valence'] ?? 0.0;
      final arousal =
          calculateCircumplex(totalPressDurations)['arousal'] ?? 0.0;

      // Convert image to file
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final buffer = byteData!.buffer;
      final file = File(
        '${Directory.systemTemp.path}/canvas_${DateTime.now().millisecondsSinceEpoch}.png',
      )..writeAsBytesSync(buffer.asUint8List());

      debugPrint('🚀 Sending API request...');
      debugPrint('📝 Mood text: $moodText');
      debugPrint('📊 Valence: $valence, Arousal: $arousal');
      debugPrint('👤 UID: $uid');

      // Call API
      final playlists = await ApiService.recommendPlaylists(
        canvasImage: file,
        moodText: moodText,
        valence: valence,
        arousal: arousal,
        uid: uid,
      );

      debugPrint('✅ API response received: ${playlists.length} playlists');
      return playlists;
    } catch (e) {
      debugPrint('❌ Error in sendData: $e');
      return [];
    }
  }

  void toggleTextField() {
    isTextFieldVisible = !isTextFieldVisible;
    onStateChanged();
  }

  void updateCanvas() {
    onStateChanged();
  }

  void addShape(Color color, Size canvasSize) {
    final maxWidth = canvasSize.width;
    final maxHeight = canvasSize.height;

    final double x = _random.nextDouble() * maxWidth;
    final double y = _random.nextDouble() * maxHeight;
    final position = Offset(x, y);
    final size = _random.nextDouble() * 40 + 16;

    shapes.add(
      BlinkShape(
        position,
        size,
        color,
        rotation: _random.nextDouble() * pi * 2,
        scale: _random.nextDouble() * 0.6 + 0.7,
      ),
    );
  }
}
