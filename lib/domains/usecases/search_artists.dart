import 'package:moodsic/features/survey/viewmodels/artist_viewmodel.dart';

import '../../data/repositories/artist_repository.dart';

class SearchArtists {
  final ArtistRepository artistRepository;

  SearchArtists() : artistRepository = ArtistRepository();

  Future<List<ArtistViewmodel>> execute(String keyword) async {
    final artists = await artistRepository.searchArtists(keyword);
    return artists.map((artist) => ArtistViewmodel.fromArtist(artist)).toList();
  }
}
