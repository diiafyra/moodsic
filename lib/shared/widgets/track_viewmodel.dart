class TrackViewmodel {
  final String id;
  final String name;
  final String? artist;
  final String? album;
  final String? imageUrl;
  final int? durationMs;

  TrackViewmodel({
    required this.id,
    required this.name,
    this.artist,
    this.album,
    this.imageUrl,
    this.durationMs,
  });

  factory TrackViewmodel.fromJson(Map<String, dynamic> json) {
    final albumData = json['album'];
    final albumName =
        albumData is Map
            ? albumData['name'] ?? 'Unknown Album'
            : (albumData ?? 'Unknown Album');
    final imageUrl =
        albumData is Map &&
                albumData['images'] != null &&
                albumData['images'].isNotEmpty
            ? albumData['images'][0]['url'] ?? ''
            : '';

    final artists = json['artist'] != null ? [json['artist']] : [];
    final artistName =
        artists.isNotEmpty && artists[0] is Map
            ? artists[0]['name']
            : 'Unknown Artist';

    return TrackViewmodel(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown Title',
      artist: artistName,
      album: albumName,
      imageUrl: imageUrl,
      durationMs: json['duration_ms'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'title: $name, artist: $artist, url $imageUrl, album $album'; // tuỳ thuộc vào fields của bạn
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'artist': artist,
    'album': album,
    'imageUrl': imageUrl,
    'durationMs': durationMs,
  };
}
