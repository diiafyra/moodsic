import 'dart:ffi';

import '../shared/external_urls.dart';
import '../shared/image_model.dart';
import 'followers.dart';

class Artist {
  // final ExternalUrls externalUrls;
  final String externalUrls;
  // final Followers followers;
  final int followers;
  final List<String> genres;
  // final String href;
  final String id;
  // final List<ImageModel> images;
  final String imageUrl;
  final String genre;
  final String name;
  final int popularity;
  // final String type;
  // final String uri;

  Artist({
    required this.externalUrls,
    required this.followers,
    required this.genres,
    // required this.href,
    required this.id,
    // required this.images,
    required this.name,
    required this.popularity,
    required this.genre,
    required this.imageUrl,
    // required this.type,
    // required this.uri,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      // externalUrls: ExternalUrls.fromJson(json['external_urls']),
      externalUrls: json['external_urls'] ?? '',

      // followers: Followers.fromJson(json['followers']),
      followers: json['followers'] ?? '',
      genres: List<String>.from(json['genres']) ?? [],
      // href: json['href'],
      id: json['id'],
      // images:
      //     (json['images'] as List)
      //         .map((image) => ImageModel.fromJson(image))
      //         .toList(),
      imageUrl: json['image_url'] ?? '',
      name: json['name'] ?? '',
      popularity: json['popularity'] ?? '',
      genre: json['genre'] ?? '',

      // type: json['type'],
      // uri: json['uri'],
    );
  }
  // String? get imageUrl => images.isNotEmpty ? images[0].url : null;
  // String? get genre => genres.isNotEmpty ? genres[0] : null;
}
