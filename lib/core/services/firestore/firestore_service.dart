import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moodsic/data/models/music_profle.dart';
import 'package:moodsic/data/models/playlist_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FirestoreService(this._firestore, this._auth);

  Future<int> getTotalUsers() async {
    developer.log(
      'FirestoreService: Getting total users',
      name: 'FirestoreService',
    );
    final snapshot = await _firestore.collection('users').get();
    developer.log(
      'FirestoreService: Total users: ${snapshot.docs.length}',
      name: 'FirestoreService',
    );
    return snapshot.docs.length;
  }

  Future<int> getTotalRequests() async {
    developer.log(
      'FirestoreService: Getting total requests',
      name: 'FirestoreService',
    );
    final snapshot = await _firestore.collection('recommendation_logs').get();
    developer.log(
      'FirestoreService: Total requests: ${snapshot.docs.length}',
      name: 'FirestoreService',
    );
    return snapshot.docs.length;
  }

  Future<List<Map<String, dynamic>>> getRecentUsers(int limit) async {
    developer.log(
      'FirestoreService: Getting recent users, limit: $limit',
      name: 'FirestoreService',
    );
    final snapshot =
        await _firestore
            .collection('users')
            .orderBy('createdAt', descending: true)
            .limit(limit)
            .get();
    final users =
        snapshot.docs
            .map(
              (doc) => {
                'uid': doc.id,
                'displayName':
                    doc.data()['displayName'] as String? ?? 'Unknown',
                'email': doc.data()['email'] as String? ?? 'No email',
              },
            )
            .toList();
    developer.log(
      'FirestoreService: Fetched ${users.length} recent users, UIDs: ${snapshot.docs.map((d) => d.id).toList()}',
      name: 'FirestoreService',
    );
    return users;
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    developer.log(
      'FirestoreService: Getting all users',
      name: 'FirestoreService',
    );
    final snapshot = await _firestore.collection('users').get();
    final users =
        snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>? ?? {};
          return {
            'uid': doc.id,
            'displayName': data['displayName'] as String? ?? 'Unknown',
            'email': data['email'] as String? ?? 'No email',
            'provider': data['provider'] as String? ?? 'Unknown',
            'createdAt': data['createdAt'] as Timestamp? ?? Timestamp.now(),
            'updatedAt': data['updatedAt'] as Timestamp?,
          };
        }).toList();
    developer.log(
      'FirestoreService: Fetched ${users.length} users',
      name: 'FirestoreService',
    );
    return users;
  }

  Future<Map<String, dynamic>> getUsersPaginated(
    int limit,
    DocumentSnapshot? lastDocument,
  ) async {
    developer.log(
      'FirestoreService: Getting paginated users, limit: $limit, lastDocument: $lastDocument',
      name: 'FirestoreService',
    );
    Query query = _firestore
        .collection('users')
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    final snapshot = await query.get();
    final users =
        snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>? ?? {};
          return {
            'uid': doc.id,
            'displayName': data['displayName'] as String? ?? 'Unknown',
            'email': data['email'] as String? ?? 'No email',
            'provider': data['provider'] as String? ?? 'Unknown',
            'createdAt': data['createdAt'] as Timestamp? ?? Timestamp.now(),
            'updatedAt': data['updatedAt'] as Timestamp?,
          };
        }).toList();
    developer.log(
      'FirestoreService: Fetched ${users.length} paginated users, UIDs: ${snapshot.docs.map((d) => d.id).toList()}',
      name: 'FirestoreService',
    );
    return {
      'users': users,
      'lastDocument': snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
    };
  }

  Future<void> deleteUser(String uid) async {
    developer.log(
      'FirestoreService: Deleting user $uid',
      name: 'FirestoreService',
    );
    await _firestore.collection('users').doc(uid).delete();
    developer.log(
      'FirestoreService: User $uid deleted',
      name: 'FirestoreService',
    );
  }

  Future<void> saveMusicProfile(MusicProfile profile) async {
    try {
      final uid = _auth.currentUser?.uid;
      developer.log('saveMusicProfile: UID = $uid', name: 'FirestoreService');
      if (uid == null) throw Exception('User not logged in');

      final profileRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('profiles');

      // Đọc tất cả profile hiện có để kiểm tra
      final existing =
          await profileRef.where('isActive', isEqualTo: true).get();
      developer.log(
        'saveMusicProfile: Found ${existing.docs.length} active profiles',
        name: 'FirestoreService',
      );

      // Tạo batch để cập nhật
      final batch = _firestore.batch();

      // Tắt isActive của tất cả profile hiện có
      for (final doc in existing.docs) {
        developer.log(
          'saveMusicProfile: Deactivating profile ${doc.id}',
          name: 'FirestoreService',
        );
        batch.update(doc.reference, {'isActive': false});
      }

      // Thêm profile mới với isActive = true
      final newDoc = profileRef.doc(); // Sử dụng ID tự sinh
      developer.log(
        'saveMusicProfile: Creating new profile with ID ${newDoc.id}',
        name: 'FirestoreService',
      );
      batch.set(newDoc, {
        ...profile.toJson(),
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Commit batch
      await batch.commit();
      developer.log(
        'saveMusicProfile: Profile saved successfully',
        name: 'FirestoreService',
      );
    } catch (e) {
      developer.log(
        'saveMusicProfile: Failed to save profile: $e',
        name: 'FirestoreService',
        error: e,
      );
      throw Exception('Failed to save music profile: $e');
    }
  }

  Future<MusicProfile?> getMusicProfile() async {
    try {
      final uid = _auth.currentUser?.uid;
      developer.log('getMusicProfile: UID = $uid', name: 'FirestoreService');
      if (uid == null) throw Exception('User not logged in');

      final profileRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('profiles');

      final query =
          await profileRef.where('isActive', isEqualTo: true).limit(1).get();
      developer.log(
        'getMusicProfile: Found ${query.docs.length} active profiles',
        name: 'FirestoreService',
      );

      if (query.docs.isEmpty) {
        developer.log(
          'getMusicProfile: No active profile found',
          name: 'FirestoreService',
        );
        return null;
      }

      final activeProfile = MusicProfile.fromJson(query.docs.first.data());
      developer.log(
        'getMusicProfile: Retrieved profile = ${activeProfile.toJson()}',
        name: 'FirestoreService',
      );
      return activeProfile;
    } catch (e) {
      developer.log(
        'getMusicProfile: Failed to get profile: $e',
        name: 'FirestoreService',
        error: e,
      );
      throw Exception('Failed to get music profile: $e');
    }
  }

  Future<void> likePlaylist(PlaylistModel playlist) async {
    if (_auth.currentUser == null) {
      throw Exception('chưa đăng nhập');
    }
    final docRef = _firestore
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .collection('likedPlaylists')
        .doc(playlist.id);

    await docRef.set(playlist.toJson());
  }

  /// ✅ Bỏ thích một playlist
  Future<void> unlikePlaylist(String playlistId) async {
    if (_auth.currentUser == null) {
      throw Exception('chưa đăng nhập');
    }
    final docRef = _firestore
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .collection('likedPlaylists')
        .doc(playlistId);

    await docRef.delete();
  }

  /// ✅ Lấy danh sách playlist đã thích
  Future<List<PlaylistModel>> getLikedPlaylists() async {
    if (_auth.currentUser == null) {
      throw Exception('chưa đăng nhập');
    }
    final snapshot =
        await _firestore
            .collection('users')
            .doc(_auth.currentUser?.uid)
            .collection('likedPlaylists')
            .get();

    return snapshot.docs
        .map((doc) => PlaylistModel.fromFirestore(doc.data()))
        .toList();
  }
}
