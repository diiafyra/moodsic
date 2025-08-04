import 'package:moodsic/core/services/api_service.dart';
import 'package:moodsic/shared/widgets/track_viewmodel.dart';

class TrackRepository {
  Future<List<TrackViewmodel>> searchTracks(String keyword) async {
    return await ApiService.searchTracks(keyword);
  }
}
