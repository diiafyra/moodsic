import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String email;
  final String displayName;
  final String provider;
  final Timestamp createdAt;
  final Timestamp? updatedAt;

  User({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.provider,
    required this.createdAt,
    this.updatedAt,
  });
}
