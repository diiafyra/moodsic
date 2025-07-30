import '../artist/artist.dart';
import '../shared/image_model.dart';
import '../shared/restrictions.dart';

import 'album_tracks.dart';
import 'copyright_info.dart';
import '../shared/external_ids.dart';
import '../shared/external_urls.dart';

class Album {
  final String albumType;
  final int totalTracks;
  final List<String> availableMarkets;
  final ExternalUrls externalUrls;
  final String href;
  final String id;
  final List<ImageModel> images;
  final String name;
  final String releaseDate;
  final String releaseDatePrecision;
  final Restrictions? restrictions;
  final String uri;
  final List<Artist> artists;
  final AlbumTracks tracks;
  final List<CopyrightInfo> copyrights;
  final ExternalIds externalIds;
  final List<String> genres;
  final String label;
  final int popularity;

  Album({
    required this.albumType,
    required this.totalTracks,
    required this.availableMarkets,
    required this.externalUrls,
    required this.href,
    required this.id,
    required this.images,
    required this.name,
    required this.releaseDate,
    required this.releaseDatePrecision,
    required this.restrictions,
    required this.uri,
    required this.artists,
    required this.tracks,
    required this.copyrights,
    required this.externalIds,
    required this.genres,
    required this.label,
    required this.popularity,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      albumType: json['album_type'],
      totalTracks: json['total_tracks'],
      availableMarkets: List<String>.from(json['available_markets']),
      externalUrls: ExternalUrls.fromJson(json['external_urls']),
      href: json['href'],
      id: json['id'],
      images: (json['images'] as List)
          .map((img) => ImageModel.fromJson(img))
          .toList(),
      name: json['name'],
      releaseDate: json['release_date'],
      releaseDatePrecision: json['release_date_precision'],
      restrictions: json['restrictions'] != null
          ? Restrictions.fromJson(json['restrictions'])
          : null,
      uri: json['uri'],
      artists: (json['artists'] as List)
          .map((artist) => Artist.fromJson(artist))
          .toList(),
      tracks: AlbumTracks.fromJson(json['tracks']),
      copyrights: (json['copyrights'] as List)
          .map((c) => CopyrightInfo.fromJson(c))
          .toList(),
      externalIds: ExternalIds.fromJson(json['external_ids']),
      genres: List<String>.from(json['genres']),
      label: json['label'],
      popularity: json['popularity'],
    );
  }
}
