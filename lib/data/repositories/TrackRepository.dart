import 'package:moodsic/core/config/dependencies.dart';
import 'package:moodsic/core/services/api_service.dart';
import 'package:moodsic/shared/widgets/track_viewmodel.dart';

class TrackRepository {
  Future<List<TrackViewmodel>> searchTracks(String keyword) async {
    final apiService = getIt<ApiService>();
    return await apiService.searchTracks(keyword);
  }
}
