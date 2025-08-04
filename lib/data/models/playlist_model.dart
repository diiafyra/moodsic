import 'dart:convert' show json;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PlaylistModel {
  final String id;
  final String? name;
  final String? imageUrl;
  final String description;
  final List<String> artists;
  final DateTime? createdDate; // từ Spotify nếu có
  final DateTime? likedAt; // thời điểm user like playlist
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
    this.likedAt,
    this.trackHref,
    this.totalTracks,
    required this.isMain,
  });

  /// ✅ Tạo từ JSON Spotify API
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

  /// ✅ Tạo từ Firestore
  factory PlaylistModel.fromFirestore(Map<String, dynamic> data) {
    return PlaylistModel(
      id: data['id'],
      name: data['name'],
      imageUrl: data['imageUrl'],
      description: data['description'] ?? '',
      artists: List<String>.from(data['artists'] ?? []),
      createdDate:
          (data['createdDate'] != null)
              ? (data['createdDate'] as Timestamp).toDate()
              : null,
      isMain: data['isMain'] ?? false,
      likedAt:
          (data['createdAt'] != null)
              ? DateTime.tryParse(data['createdAt'])
              : null,
      trackHref: data['trackHref'],
      totalTracks: data['totalTracks'],
    );
  }

  /// ✅ Chuyển thành JSON (Firestore hoặc local)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'description': description,
      'artists': artists,
      'createdAt': createdDate,
      'isMain': isMain,
      'trackHref': trackHref,
      'likedAt': likedAt?.toIso8601String(),
      'totalTracks': totalTracks,
    };
  }
}
