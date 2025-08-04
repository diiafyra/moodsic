import 'package:flutter/material.dart';
import 'package:moodsic/core/services/api_service.dart';

class PlayController extends ChangeNotifier {
  String? _currentlyPlayingId;

  String? get currentlyPlayingId => _currentlyPlayingId;

  bool isPlaying(String playlistId) => _currentlyPlayingId == playlistId;

  Future<void> togglePlay(String playlistId) async {
    if (_currentlyPlayingId == playlistId) {
      // Đang phát → Pause
      await ApiService.pausePlayback();
      _currentlyPlayingId = null;
    } else {
      // Đang phát cái khác → Pause cái cũ, Play cái mới
      if (_currentlyPlayingId != null) {
        await ApiService.pausePlayback();
      }
      await ApiService.playPlaylist(playlistId);
      _currentlyPlayingId = playlistId;
    }

    notifyListeners();
  }
}
