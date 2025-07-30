class TrackDto {
  final String id;
  final String title;
  final String? url;
  final List<String> artists;

  TrackDto({
    required this.id,
    required this.title,
    this.url,
    required this.artists,
  });
}