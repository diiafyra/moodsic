import 'package:flutter/material.dart';

class PlaylistModel {
  final String id;
  final String? name;
  final String? imageUrl;
  final String description;
  final List<String> artists;
  final DateTime? createdDate;
  final bool isMain;
  final String? trackHref;
  final int? totalTracks;

  PlaylistModel({
    required this.id,
    this.name,
    this.imageUrl,
    required this.description,
    required this.artists,
    this.createdDate,
    this.trackHref,
    this.totalTracks,
    required this.isMain,
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    final images = json['images'] as List<dynamic>?;
    final tracksInfo = json['tracks'] as Map<String, dynamic>?;
    debugPrint(json['id']);

    return PlaylistModel(
      id: json['id'] as String,
      name: json['name'],
      imageUrl:
          images != null && images.isNotEmpty ? images.first['url'] : null,
      description: json['description'] ?? '',
      artists: [
        if (json['owner'] != null && json['owner']['display_name'] != null)
          json['owner']['display_name'] ?? '',
      ],
      isMain: false,
      createdDate: null,
      trackHref: tracksInfo?['href'],
      totalTracks: tracksInfo?['total'],
    );
  }
}
