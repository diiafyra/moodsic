import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:moodsic/data/models/music_profle.dart';
import 'package:moodsic/data/models/playlist_model.dart';
import 'package:moodsic/features/recommendation_analytics_page/Models/recommendation_log_firetore.dart';
import 'package:moodsic/features/recommendation_logs/models/recommendation_log.dart';

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

  /// ✅ Lấy danh sách playlist đã thích
  Future<List<PlaylistModel>> getMyPlaylists() async {
    if (_auth.currentUser == null) {
      throw Exception('chưa đăng nhập');
    }
    final snapshot =
        await _firestore
            .collection('users')
            .doc(_auth.currentUser?.uid)
            .collection('my_playlists')
            .get();

    return snapshot.docs
        .map((doc) => PlaylistModel.fromFirestore(doc.data()))
        .toList();
  }

  Stream<List<RecommendationLog>> getUserRecommendationLogs() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return const Stream.empty();
    }

    final safeUid = uid.replaceAll(RegExp(r'[:\/]'), '_');

    return _firestore
        .collection('recommendation_logs')
        .doc(safeUid)
        .collection('logs')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => RecommendationLog.fromFirestore(doc))
              .toList();
        });
  }

  Future<List<RecommendationLog>> getUserRecommendationLogsPaginated(
    String uid, {
    DocumentSnapshot? lastDocument,
    int limit = 20,
  }) async {
    final safeUid = uid.replaceAll(RegExp(r'[:\/]'), '_');

    Query query = _firestore
        .collection('recommendation_logs')
        .doc(safeUid)
        .collection('logs')
        .orderBy('timestamp', descending: true)
        .limit(limit);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    QuerySnapshot snapshot = await query.get();
    return snapshot.docs
        .map((doc) => RecommendationLog.fromFirestore(doc))
        .toList();
  }

  void debugRecommendationLogs() async {
    final startDate = DateTime.now().subtract(const Duration(days: 7));
    final endDate = DateTime.now();

    try {
      final logs = await getUserRecommendationLogFirestoresByTimeRange(
        startDate: startDate,
        endDate: endDate,
      );

      debugPrint('📋 [Logs trong khoảng thời gian]');
      for (var log in logs) {
        debugPrint(
          log.toString(),
        ); // Giả sử bạn đã override toString() trong model
      }
    } catch (e, stack) {
      debugPrint('❌ Lỗi khi lấy logs: $e');
      debugPrint('🧱 Stack: $stack');
    }
  }

  void debugRecommendationStats() async {
    final startDate = DateTime.now().subtract(const Duration(days: 7));
    final endDate = DateTime.now();

    try {
      final stats = await getRecommendationLogFirestoreStats(
        startDate: startDate,
        endDate: endDate,
      );

      debugPrint('📊 [Thống kê recommendation]');
      stats.forEach((key, value) {
        debugPrint('$key: $value');
      });
    } catch (e, stack) {
      debugPrint('❌ Lỗi khi tính stats: $e');
      debugPrint('🧱 Stack: $stack');
    }
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
  getAllRecommendationLogFirestoresByTimeRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final startTimestamp = Timestamp.fromDate(startDate);
    final endTimestamp = Timestamp.fromDate(endDate);

    // Use collectionGroup to query all 'logs' subcollections from all users
    final querySnapshot =
        await _firestore
            .collectionGroup('logs')
            .where('timestamp', isGreaterThanOrEqualTo: startTimestamp)
            .where('timestamp', isLessThanOrEqualTo: endTimestamp)
            .orderBy('timestamp', descending: true)
            .get();

    return querySnapshot.docs;
  }

  Future<List<RecommendationLogFirestore>>
  getUserRecommendationLogFirestoresByTimeRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final querySnapshot =
        await _firestore
            .collectionGroup('logs') // Lấy từ tất cả users
            .where(
              'timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
            )
            .where(
              'timestamp',
              isLessThanOrEqualTo: Timestamp.fromDate(endDate),
            )
            .orderBy('timestamp', descending: true)
            .get();

    return querySnapshot.docs
        .map((doc) => RecommendationLogFirestore.fromFirestore(doc))
        .toList();
  }

  Future<List<RecommendationLogFirestore>>
  getAllUserRecommendationLogsByTimeRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final List<RecommendationLogFirestore> allLogs = [];

    // Lấy danh sách tất cả các UID trong collection 'recommendation_logs'
    final userDocs = await _firestore.collection('recommendation_logs').get();

    for (final userDoc in userDocs.docs) {
      final logsSnapshot =
          await _firestore
              .collection('recommendation_logs')
              .doc(userDoc.id)
              .collection('logs')
              .where(
                'timestamp',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
              )
              .where(
                'timestamp',
                isLessThanOrEqualTo: Timestamp.fromDate(endDate),
              )
              .orderBy('timestamp', descending: true)
              .get();

      final logs =
          logsSnapshot.docs
              .map((doc) => RecommendationLogFirestore.fromFirestore(doc))
              .toList();

      allLogs.addAll(logs);
    }

    return allLogs;
  }

  // Hàm lấy thống kê tổng hợp - đơn giản
  Future<Map<String, dynamic>> getRecommendationLogFirestoreStats({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final DateTime start =
        startDate ?? DateTime.now().subtract(const Duration(days: 7));
    final DateTime end = endDate ?? DateTime.now();

    final snapshot =
        await FirebaseFirestore.instance
            .collection('recommendation_logs')
            .where(
              'timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(start),
            )
            .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(end))
            .orderBy('timestamp', descending: true)
            .get();

    final logs =
        snapshot.docs.map((doc) {
          final data = doc.data();
          return RecommendationLogFirestore.fromJson(data);
        }).toList();

    return _calculateStats(logs);
  }

  // Hàm tính toán thống kê từ logs - đơn giản
  Map<String, dynamic> _calculateStats(List<RecommendationLogFirestore> logs) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    final totalRequests = logs.length;

    final todayRequests =
        logs.where((log) {
          final logDate = log.timestamp.toDate();
          return logDate.isAfter(today) && logDate.isBefore(tomorrow);
        }).length;

    double avgPlaylistsPerRequest = 0.0;
    if (logs.isNotEmpty) {
      final totalPlaylists = logs.fold<int>(
        0,
        (sum, log) => sum + log.playlists.length,
      );
      avgPlaylistsPerRequest = totalPlaylists / logs.length;
    }

    final dailyRequests = _calculateDailyRequests(logs);
    final moodDistribution = _calculateMoodDistribution(logs);
    final recentLogs = logs.take(10).toList();

    return {
      'totalRequests': totalRequests,
      'todayRequests': todayRequests,
      'avgPlaylistsPerRequest': avgPlaylistsPerRequest,
      'dailyRequests': dailyRequests,
      'moodDistribution': moodDistribution,
      'recentLogs': recentLogs,
    };
  }

  Map<String, int> _calculateDailyRequests(
    List<RecommendationLogFirestore> logs,
  ) {
    final Map<String, int> dailyRequests = {};
    for (final log in logs) {
      final logDate = log.timestamp.toDate();
      final dateKey = _formatDateKey(logDate);
      dailyRequests[dateKey] = (dailyRequests[dateKey] ?? 0) + 1;
    }
    return dailyRequests;
  }

  String _formatDateKey(DateTime date) {
    return '${date.month}/${date.day}';
  }

  Map<String, int> _calculateMoodDistribution(
    List<RecommendationLogFirestore> logs,
  ) {
    final Map<String, int> moodCounts = {};
    for (final log in logs) {
      final mood = log.moodLabel.isEmpty ? 'Unknown' : log.moodLabel;
      moodCounts[mood] = (moodCounts[mood] ?? 0) + 1;
    }
    return moodCounts;
  }
}
