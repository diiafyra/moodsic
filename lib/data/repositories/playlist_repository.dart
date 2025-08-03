import 'dart:io';

import 'package:moodsic/core/services/api_service.dart';
import 'package:moodsic/data/models/playlist_model.dart';

class PlaylistRepository {
  Future<List<PlaylistModel>> getRecommendations({
    required File canvasImage,
    required String moodText,
    required double valence,
    required double arousal,
    required String uid,
  }) async {
    return await ApiService.recommendPlaylists(
      canvasImage: canvasImage,
      moodText: moodText,
      valence: valence,
      arousal: arousal,
      uid: uid,
    );
  }
}
