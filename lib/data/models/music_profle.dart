import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moodsic/features/survey/viewmodels/artist_viewmodel.dart';
import 'package:moodsic/shared/widgets/track_viewmodel.dart';

class MusicProfile {
  final List<String> genres;
  final List<ArtistViewmodel> artists;
  final List<TrackViewmodel> tracks;
  final bool isActive;
  final DateTime? createdAt;

  MusicProfile({
    required this.genres,
    required this.artists,
    required this.tracks,
    this.isActive = false,
    this.createdAt,
  });

  factory MusicProfile.fromJson(Map<String, dynamic> json) {
    return MusicProfile(
      genres: List<String>.from(json['genres'] ?? []),
      artists:
          (json['artists'] as List<dynamic>? ?? [])
              .map((e) => ArtistViewmodel.fromJson(e as Map<String, dynamic>))
              .toList(),
      tracks:
          (json['tracks'] as List<dynamic>? ?? [])
              .map((e) => TrackViewmodel.fromJson(e as Map<String, dynamic>))
              .toList(),
      isActive: json['isActive'] ?? false,
      createdAt:
          json['createdAt'] != null
              ? (json['createdAt'] as Timestamp).toDate()
              : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'genres': genres,
    'artists': artists.map((e) => e.toJson()).toList(),
    'tracks': tracks.map((e) => e.toJson()).toList(),
    'isActive': isActive,
    'createdAt': createdAt ?? FieldValue.serverTimestamp(),
  };
}
