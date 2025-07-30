import 'package:untitled/shared/widgets/track_dto.dart';

class PlaylistDto {
  final String id;
  final String? imageUrl;
  final String description;
  final String? name;
  final List<String> artists;
  final bool isPlaying;
  final bool isLiked;
  final DateTime? createdDate;
  final List<TrackDto>? tracks;
  final bool isMain;

  PlaylistDto({
    required this.id,
    this.imageUrl,
    required this.description,
    this.name,
    required this.artists,
    this.isPlaying = false,
    this.isLiked = false,
    this.createdDate,
    this.tracks,
    required this.isMain
  });
}