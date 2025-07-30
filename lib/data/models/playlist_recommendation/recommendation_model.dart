
import 'package:untitled/data/models/playlist_recommendation/seed.dart';

import '../track.dart';

class RecommendationResponse {
  final List<Seed> seeds;
  final List<Track> tracks;

  RecommendationResponse({required this.seeds, required this.tracks});

  factory RecommendationResponse.fromJson(Map<String, dynamic> json) {
    return RecommendationResponse(
      seeds: (json['seeds'] as List<dynamic>)
          .map((e) => Seed.fromJson(e))
          .toList(),
      tracks: (json['tracks'] as List<dynamic>)
          .map((e) => Track.fromJson(e))
          .toList(),
    );
  }
}