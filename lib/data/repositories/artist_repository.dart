import 'package:moodsic/core/config/dependencies.dart';
import 'package:moodsic/data/models/artist/artist.dart';
import '../../core/services/api_service.dart';

class ArtistRepository {
  Future<List<Artist>> searchArtists(String keyword) async {
    final apiService = getIt<ApiService>();
    return await apiService.searchArtists(keyword);
  }
}
