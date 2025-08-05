import 'package:flutter/foundation.dart';
import 'package:moodsic/core/config/dependencies.dart';
import 'package:moodsic/core/services/api_service.dart';
import 'package:moodsic/data/models/playlist_model.dart';
import 'package:moodsic/shared/widgets/track_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlaylistViewModel {
  PlaylistModel playlist;
  bool _isLiked;
  bool _isPlaying;
  List<TrackViewmodel> tracks = [];
  int currentPage = 0;
  bool hasMoreTracks = true;
  bool isLoading = false;
  final int limit = 100;

  PlaylistViewModel({
    required this.playlist,
    bool isLiked = false,
    bool isPlaying = false,
  }) : _isLiked = isLiked,
       _isPlaying = isPlaying;

  String get id => playlist.id;
  String get name => playlist.name ?? '';
  String get imageUrl => playlist.imageUrl ?? '';
  String get description => playlist.description;
  List<String> get artists => playlist.artists;

  bool get isLiked => _isLiked;
  bool get isPlaying => _isPlaying;

  Future<void> fetchTracks({bool reset = false}) async {
    print('🔄 Fetching tracks for playlist: $name (ID: $id)');
    // Lưu id vào shared preferences
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('id_newTracks', id);

    if (isLoading || !hasMoreTracks) {
      debugPrint('⏳ Đang tải hoặc không còn track nào để tải.');
      return;
    }

    isLoading = true;
    debugPrint('🚀 Bắt đầu fetchTracks | reset = $reset');

    try {
      if (reset) {
        currentPage = 0;
        tracks.clear();
        hasMoreTracks = true;
        debugPrint('🔄 Đã reset track list và phân trang.');
      }
      final apiService = getIt<ApiService>();

      final newTracks = await apiService.fetchTracksFromPlaylist(
        playlistId: id,
        limit: limit,
      );

      debugPrint('📥 Đã fetch ${newTracks.length} track từ API.');
      // for (final track in newTracks) {
      //   debugPrint('🎵 Track: ${track.name} - ${track.artist}');
      // }

      tracks.addAll(newTracks);
      hasMoreTracks = newTracks.length == limit;
      currentPage++;
      debugPrint('✅ currentPage: $currentPage | hasMoreTracks: $hasMoreTracks');
    } catch (e, stack) {
      debugPrint('❌ Lỗi khi fetch tracks: $e\n$stack');
      hasMoreTracks = false;
    } finally {
      isLoading = false;
      debugPrint('🏁 Kết thúc fetchTracks');
    }
  }
}
