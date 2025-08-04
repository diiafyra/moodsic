import 'album/album.dart';
import 'shared/restrictions.dart';
import 'artist/artist.dart';
import 'shared/external_ids.dart';
import 'shared/external_urls.dart';

class Track {
  final Album album;
  //
  final String? artist;
  //
  final List<String> availableMarkets;
  //
  final int durationMs;
  //
  final String id;
  //
  final bool isPlayable;
  //
  final String name;
  //
  final String? previewUrl;
  //
  final int trackNumber;
  final String type;
  final String uri;
  final bool isLocal;
  final int popularity;
  final Map<String, dynamic> linkedFrom;
  final Restrictions? restrictions;
  final String href;
  final bool explicit;
  final ExternalIds externalIds;
  final ExternalUrls externalUrls;
  final int discNumber;

  Track({
    required this.album,
    this.artist,
    required this.availableMarkets,
    required this.discNumber,
    required this.durationMs,
    required this.explicit,
    required this.externalIds,
    required this.externalUrls,
    required this.href,
    required this.id,
    required this.isPlayable,
    required this.linkedFrom,
    required this.restrictions,
    required this.name,
    required this.popularity,
    required this.previewUrl,
    required this.trackNumber,
    required this.type,
    required this.uri,
    required this.isLocal,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    final artists = json['artists'] as List<dynamic>;
    final album = json['album'];

    return Track(
      album: album['name'] ?? 'Unknown Album',
      artist:
          artists.isNotEmpty
              ? artists.map((a) => a['name'] ?? 'Unknown').join(', ')
              : 'Unknown Artist',
      availableMarkets: List<String>.from(json['available_markets']),
      discNumber: json['disc_number'],
      durationMs: json['duration_ms'] ?? 0,
      explicit: json['explicit'],
      externalIds: ExternalIds.fromJson(json['external_ids']),
      externalUrls: ExternalUrls.fromJson(json['external_urls']),
      href: json['href'],
      id: json['id'],
      isPlayable: json['is_playable'],
      linkedFrom: json['linked_from'] ?? {},
      restrictions:
          json['restrictions'] != null
              ? Restrictions.fromJson(json['restrictions'])
              : null,
      name: json['name'] ?? 'Unknown Title',
      popularity: json['popularity'],
      previewUrl: json['preview_url'],
      trackNumber: json['track_number'],
      type: json['type'],
      uri: json['uri'],
      isLocal: json['is_local'],
    );
  }
}
