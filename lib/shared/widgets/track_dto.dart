class TrackDto {
  final String id;
  final String name;
  final String? artist;
  final String? album;
  final String? imageUrl;
  final int? durationMs;

  TrackDto({
    required this.id,
    required this.name,
    this.artist,
    this.album,
    this.imageUrl,
    this.durationMs,
  });

  factory TrackDto.fromJson(Map<String, dynamic> json) {
    final album = json['album'];
    final artists = json['artists'] as List<dynamic>;

    return TrackDto(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown Title',
      artist:
          artists.isNotEmpty
              ? artists.map((a) => a['name'] ?? 'Unknown').join(', ')
              : 'Unknown Artist',
      album: album['name'] ?? 'Unknown Album',
      imageUrl:
          (album['images'] != null && album['images'].isNotEmpty)
              ? album['images'][0]['url'] ?? ''
              : '',
      durationMs: json['duration_ms'] ?? 0,
    );
  }
}
