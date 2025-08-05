import 'package:flutter/material.dart';
import 'package:moodsic/core/config/dependencies.dart';
import 'package:moodsic/core/services/api_service.dart';

class PlayController extends ChangeNotifier {
  String? _currentlyPlayingId;

  String? get currentlyPlayingId => _currentlyPlayingId;

  bool isPlaying(String playlistId) => _currentlyPlayingId == playlistId;
  final apiService = getIt<ApiService>();

  Future<void> togglePlay(String playlistId) async {
    if (_currentlyPlayingId == playlistId) {
      // Đang phát → Pause
      await apiService.pausePlayback();
      _currentlyPlayingId = null;
    } else {
      // Đang phát cái khác → Pause cái cũ, Play cái mới
      if (_currentlyPlayingId != null) {
        await apiService.pausePlayback();
      }
      await apiService.playPlaylist(playlistId);
      _currentlyPlayingId = playlistId;
    }

    notifyListeners();
  }
}
