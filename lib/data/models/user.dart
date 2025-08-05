import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String provider;
  final Timestamp createdAt;
  final Timestamp? updatedAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.provider,
    required this.createdAt,
    this.updatedAt,
  });

  /// ✅ Parse từ Firestore (map + uid riêng)
  factory UserModel.fromMap(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      email: data['email'] ?? 'No email',
      displayName: data['displayName'] ?? 'Unknown',
      provider: data['provider'] ?? 'Unknown',
      createdAt: _parseTimestamp(data['createdAt']),
      updatedAt: _tryParseNullableTimestamp(data['updatedAt']),
    );
  }

  /// ✅ Parse từ JSON (đã có uid trong map)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      email: json['email'] ?? 'No email',
      displayName: json['displayName'] ?? 'Unknown',
      provider: json['provider'] ?? 'Unknown',
      createdAt: _parseTimestamp(json['createdAt']),
      updatedAt: _tryParseNullableTimestamp(json['updatedAt']),
    );
  }

  /// ✅ Convert sang JSON thuần
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'provider': provider,
      'createdAt': createdAt.toDate().toIso8601String(),
      'updatedAt': updatedAt?.toDate().toIso8601String(),
    };
  }

  /// ✅ Convert sang Firestore map
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'provider': provider,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// Helper - parse createdAt (Timestamp hoặc ISO String)
  static Timestamp _parseTimestamp(dynamic value) {
    if (value is Timestamp) return value;
    if (value is String) {
      try {
        return Timestamp.fromDate(DateTime.parse(value));
      } catch (_) {}
    }
    return Timestamp.now(); // fallback
  }

  /// Helper - parse updatedAt (nullable)
  static Timestamp? _tryParseNullableTimestamp(dynamic value) {
    if (value is Timestamp) return value;
    if (value is String) {
      try {
        return Timestamp.fromDate(DateTime.parse(value));
      } catch (_) {}
    }
    return null;
  }
}
