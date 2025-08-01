import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> getTotalUsers() async {
    print('FirestoreService: Getting total users');
    final snapshot = await _firestore.collection('users').get();
    print('FirestoreService: Total users: ${snapshot.docs.length}');
    return snapshot.docs.length;
  }

  Future<int> getTotalRequests() async {
    print('FirestoreService: Getting total requests');
    final snapshot =
        await _firestore.collection('recommendation_requests').get();
    print('FirestoreService: Total requests: ${snapshot.docs.length}');
    return snapshot.docs.length;
  }

  Future<List<Map<String, dynamic>>> getRecentUsers(int limit) async {
    print('FirestoreService: Getting recent users, limit: $limit');
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
                'displayName': doc.data()['displayName'] ?? 'Unknown',
                'email': doc.data()['email'] ?? 'No email',
              },
            )
            .toList();
    print('FirestoreService: Fetched ${users.length} recent users');
    return users;
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    print('FirestoreService: Getting all users');
    final snapshot = await _firestore.collection('users').get();
    final users =
        snapshot.docs
            .map(
              (doc) => {
                'uid': doc.id,
                'displayName': doc.data()['displayName'] ?? 'Unknown',
                'email': doc.data()['email'] ?? 'No email',
                'provider': doc.data()['provider'] ?? 'Unknown',
                'createdAt': doc.data()['createdAt'] ?? Timestamp.now(),
                'updatedAt': doc.data()['updatedAt'],
              },
            )
            .toList();
    print('FirestoreService: Fetched ${users.length} users');
    return users;
  }

  Future<Map<String, dynamic>> getUsersPaginated(
    int limit,
    DocumentSnapshot? lastDocument,
  ) async {
    print(
      'FirestoreService: Getting paginated users, limit: $limit, lastDocument: $lastDocument',
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
            'displayName': data['displayName'] ?? 'Unknown',
            'email': data['email'] ?? 'No email',
            'provider': data['provider'] ?? 'Unknown',
            'createdAt': data['createdAt'] ?? Timestamp.now(),
            'updatedAt': data['updatedAt'],
          };
        }).toList();

    print('FirestoreService: Fetched ${users.length} paginated users');
    return {
      'users': users,
      'lastDocument': snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
    };
  }

  Future<void> deleteUser(String uid) async {
    print('FirestoreService: Deleting user $uid');
    await _firestore.collection('users').doc(uid).delete();
    print('FirestoreService: User $uid deleted');
  }
}
