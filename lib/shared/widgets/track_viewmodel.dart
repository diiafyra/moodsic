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
    final album = json['album'];
    final artists = json['artists'] as List<dynamic>;

    return TrackViewmodel(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown Title',
      artist:
          artists.isNotEmpty
              ? artists.map((a) => a['name'] ?? 'Unknown').join(', ')
              : 'Unknown Artist',
      album: album['name'] ?? 'Unknown Album',
      // imageUrl:
      //     (album['images'] != null && album['images'].isNotEmpty)
      //         ? album['images'][0]['url'] ?? ''
      //         : '',
      imageUrl: album['image_url'],
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
