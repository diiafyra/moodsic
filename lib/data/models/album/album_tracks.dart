import '../track.dart';

class AlbumTracks {
  final int total;
  final List<Track> items;

  AlbumTracks({required this.total, required this.items});

  factory AlbumTracks.fromJson(Map<String, dynamic> json) {
    return AlbumTracks(
      total: json['total'],
      items: (json['items'] as List)
          .map((item) => Track.fromJson(item))
          .toList(),
    );
  }
}
