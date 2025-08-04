import 'package:moodsic/data/models/track.dart';
import 'package:moodsic/data/repositories/TrackRepository.dart';
import 'package:moodsic/shared/widgets/track_viewmodel.dart';

class SearchTracks {
  final TrackRepository trackRepository;

  SearchTracks() : trackRepository = TrackRepository();

  Future<List<TrackViewmodel>> execute(String keyword) async {
    final tracks = await trackRepository.searchTracks(keyword);
    return tracks;
  }
}
