import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class RecommendationLogFirestore {
  final String id;
  final String moodText;
  final Map<String, double> circumplex;
  final List<String> keywords;
  final List<Map<String, dynamic>> playlists;
  final String imageUrl;
  final Timestamp timestamp;

  // Derived properties
  String get moodLabel {
    if (circumplex.isEmpty) return 'Unknown';

    final valence = circumplex['valence'] ?? 0.0;
    final arousal = circumplex['arousal'] ?? 0.0;

    // Xác định mood dựa trên circumplex model
    if (valence > 0 && arousal > 0) {
      return 'Happy';
    } else if (valence < 0 && arousal > 0) {
      return 'Angry';
    } else if (valence > 0 && arousal < 0) {
      return 'Calm';
    } else if (valence < 0 && arousal < 0) {
      return 'Sad';
    } else {
      return 'Neutral';
    }
  }

  RecommendationLogFirestore({
    required this.id,
    required this.moodText,
    required this.circumplex,
    required this.keywords,
    required this.playlists,
    required this.imageUrl,
    required this.timestamp,
  });
  factory RecommendationLogFirestore.fromJson(Map<String, dynamic> json) {
    return RecommendationLogFirestore(
      id: json['id'],
      circumplex: json['circumplex'],
      keywords: json['keywords'],
      imageUrl: json['imageUrl'],
      timestamp: json['timestamp'] ?? Timestamp.now(),
      playlists: json['playlists'] ?? [],
      moodText: json['mood'] ?? 'unknown',
    );
  }
  // Factory constructor từ Firestore DocumentSnapshot
  factory RecommendationLogFirestore.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return RecommendationLogFirestore(
      id: doc.id,
      moodText: data['moodText'] ?? '',
      circumplex: Map<String, double>.from(data['circumplex'] ?? {}),
      keywords: List<String>.from(data['keywords'] ?? []),
      playlists: List<Map<String, dynamic>>.from(data['playlists'] ?? []),
      imageUrl: data['imageUrl'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  // Factory constructor từ Map
  factory RecommendationLogFirestore.fromMap(
    Map<String, dynamic> map,
    String id,
  ) {
    return RecommendationLogFirestore(
      id: id,
      moodText: map['moodText'] ?? '',
      circumplex: Map<String, double>.from(map['circumplex'] ?? {}),
      keywords: List<String>.from(map['keywords'] ?? []),
      playlists: List<Map<String, dynamic>>.from(map['playlists'] ?? []),
      imageUrl: map['imageUrl'] ?? '',
      timestamp: map['timestamp'] ?? Timestamp.now(),
    );
  }

  // Convert to Map để lưu vào Firestore
  Map<String, dynamic> toMap() {
    return {
      'moodText': moodText,
      'circumplex': circumplex,
      'keywords': keywords,
      'playlists': playlists,
      'imageUrl': imageUrl,
      'timestamp': timestamp,
    };
  }

  // Copy with method
  RecommendationLogFirestore copyWith({
    String? id,
    String? moodText,
    Map<String, double>? circumplex,
    List<String>? keywords,
    List<Map<String, dynamic>>? playlists,
    String? imageUrl,
    Timestamp? timestamp,
  }) {
    return RecommendationLogFirestore(
      id: id ?? this.id,
      moodText: moodText ?? this.moodText,
      circumplex: circumplex ?? this.circumplex,
      keywords: keywords ?? this.keywords,
      playlists: playlists ?? this.playlists,
      imageUrl: imageUrl ?? this.imageUrl,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  String toString() {
    return 'RecommendationLogFirestore(id: $id, moodLabel: $moodLabel, keywords: $keywords, playlistCount: ${playlists.length})';
  }

  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RecommendationLogFirestore &&
        other.id == id &&
        other.moodText == moodText &&
        other.circumplex == circumplex &&
        other.keywords == keywords &&
        other.playlists == playlists &&
        other.imageUrl == imageUrl &&
        other.timestamp == timestamp;
  }

  int get hashCode {
    return id.hashCode ^
        moodText.hashCode ^
        circumplex.hashCode ^
        keywords.hashCode ^
        playlists.hashCode ^
        imageUrl.hashCode ^
        timestamp.hashCode;
  }
}

// Extension methods cho RecommendationLogFirestore
extension RecommendationLogFirestoreExtensions on RecommendationLogFirestore {
  // Lấy tên playlist đầu tiên
  String get firstPlaylistName {
    if (playlists.isEmpty) return 'No playlist';
    return playlists.first['name'] ?? 'Unknown playlist';
  }

  // Lấy tổng số bài hát trong tất cả playlists
  int get totalTracks {
    return playlists.fold<int>(0, (sum, playlist) {
      final tracks = playlist['tracks'] as List<dynamic>? ?? [];
      return sum + tracks.length;
    });
  }

  // Kiểm tra xem có hình ảnh không
  bool get hasImage => imageUrl.isNotEmpty;

  // Lấy formatted timestamp
  String get formattedTime {
    final dateTime = timestamp.toDate();
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  // Lấy top keywords (giới hạn số lượng)
  List<String> getTopKeywords([int limit = 5]) {
    return keywords.take(limit).toList();
  }

  // Lấy mood intensity (độ mạnh của cảm xúc)
  double get moodIntensity {
    if (circumplex.isEmpty) return 0.0;

    final valence = circumplex['valence'] ?? 0.0;
    final arousal = circumplex['arousal'] ?? 0.0;

    // Tính khoảng cách từ tâm (độ mạnh cảm xúc)
    return sqrt(valence * valence + arousal * arousal);
  }
}
