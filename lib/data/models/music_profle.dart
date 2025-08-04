import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moodsic/features/survey/viewmodels/artist_viewmodel.dart';
import 'package:moodsic/shared/widgets/track_viewmodel.dart';

class MusicProfile {
  final List<String>? genres;
  final List<ArtistViewmodel>? artists;
  final List<TrackViewmodel>? tracks;
  final bool isActive;
  final DateTime? createdAt;

  MusicProfile({
    this.genres,
    this.artists,
    this.tracks,
    this.isActive = false,
    this.createdAt,
  });

  factory MusicProfile.fromJson(Map<String, dynamic> json) {
    List<String> genres = [];
    List<ArtistViewmodel> artists = [];
    List<TrackViewmodel> tracks = [];
    bool isActive = false;
    DateTime? createdAt;

    // Genres
    try {
      final genresRaw = json['genres'];
      if (genresRaw is List) {
        genres = genresRaw.whereType<String>().toList();
      } else {
        print('⚠️ genres is not a List: $genresRaw');
      }
    } catch (e, stack) {
      print('❌ Error parsing genres: $e');
      print(stack);
    }

    // Artists
    try {
      final artistsRaw = json['artists'];
      if (artistsRaw is List) {
        artists =
            artistsRaw
                .whereType<Map>()
                .map(
                  (e) => ArtistViewmodel.fromJson(Map<String, dynamic>.from(e)),
                )
                .toList();
      } else {
        print('⚠️ artists is not a List: $artistsRaw');
      }
    } catch (e, stack) {
      print('❌ Error parsing artists: $e');
      print('🔎 artistsRaw = ${json['artists']}');
      print(stack);
    }

    // Tracks
    try {
      final tracksRaw = json['tracks'];
      if (tracksRaw is List) {
        tracks =
            tracksRaw
                .whereType<Map>()
                .map(
                  (e) => TrackViewmodel.fromJson(Map<String, dynamic>.from(e)),
                )
                .toList();
      } else {
        print('⚠️ tracks is not a List: $tracksRaw');
      }
    } catch (e, stack) {
      print('❌ Error parsing tracks: $e');
      print('🔎 tracksRaw = ${json['tracks']}');
      print(stack);
    }

    // isActive
    try {
      isActive = json['isActive'] ?? false;
    } catch (e) {
      print('⚠️ Error parsing isActive: $e');
    }

    // createdAt
    try {
      final createdRaw = json['createdAt'];
      if (createdRaw is Timestamp) {
        createdAt = createdRaw.toDate();
      } else {
        print('⚠️ createdAt is not Timestamp: $createdRaw');
      }
    } catch (e) {
      print('⚠️ Error parsing createdAt: $e');
    }

    return MusicProfile(
      genres: genres,
      artists: artists,
      tracks: tracks,
      isActive: isActive,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'genres': genres,
    'artists': artists?.map((e) => e.toJson()).toList() ?? [],
    'tracks': tracks?.map((e) => e.toJson()).toList() ?? [],
    'isActive': isActive,
    'createdAt': createdAt ?? FieldValue.serverTimestamp(),
  };
}
