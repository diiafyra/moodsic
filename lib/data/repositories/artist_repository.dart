import 'package:moodsic/data/models/artist/artist.dart';
import '../../core/services/api_service.dart';

class ArtistRepository {
  Future<List<Artist>> searchArtists(String keyword) async {
    return await ApiService.searchArtists(keyword);
  }
}
