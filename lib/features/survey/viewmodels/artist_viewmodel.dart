import 'package:moodsic/data/models/artist/artist.dart';

class ArtistViewmodel {
  final String id;
  final String name;
  final String? imageUrl;
  final String? genre;

  ArtistViewmodel({
    required this.id,
    required this.name,
    this.imageUrl,
    this.genre,
  });

  factory ArtistViewmodel.fromArtist(Artist artist) {
    return ArtistViewmodel(
      id: artist.id,
      name: artist.name,
      imageUrl: artist.imageUrl,
      genre: artist.genre,
    );
  }

  factory ArtistViewmodel.fromJson(Map<String, dynamic> json) {
    return ArtistViewmodel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'],
      genre: json['genre'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'imageUrl': imageUrl,
    'genre': genre,
  };
}
