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

  factory UserModel.fromMap(Map<String, dynamic> data, String uid) {
    print('UserModel: Parsing user $uid, data: $data');

    // Handle createdAt: convert String to Timestamp if necessary
    Timestamp createdAt;
    if (data['createdAt'] is Timestamp) {
      createdAt = data['createdAt'] as Timestamp;
    } else if (data['createdAt'] is String) {
      print(
        'UserModel: Converting createdAt string "${data['createdAt']}" to Timestamp',
      );
      try {
        createdAt = Timestamp.fromDate(DateTime.parse(data['createdAt']));
      } catch (e) {
        print('UserModel: Error parsing createdAt string: $e');
        createdAt = Timestamp.now();
      }
    } else {
      print('UserModel: createdAt is null or invalid, using default');
      createdAt = Timestamp.now();
    }

    // Handle updatedAt: allow null or convert String to Timestamp
    Timestamp? updatedAt;
    if (data['updatedAt'] is Timestamp) {
      updatedAt = data['updatedAt'] as Timestamp;
    } else if (data['updatedAt'] is String) {
      print(
        'UserModel: Converting updatedAt string "${data['updatedAt']}" to Timestamp',
      );
      try {
        updatedAt = Timestamp.fromDate(DateTime.parse(data['updatedAt']));
      } catch (e) {
        print('UserModel: Error parsing updatedAt string: $e');
        updatedAt = null;
      }
    }

    return UserModel(
      uid: uid,
      email: data['email'] ?? 'No email',
      displayName: data['displayName'] ?? 'Unknown',
      provider: data['provider'] ?? 'Unknown',
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'provider': provider,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
