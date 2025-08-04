import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moodsic/core/services/firestore/firestore_service.dart';
import 'package:moodsic/data/models/user.dart';

class UserRepository {
  final FirestoreService _firestoreService;

  UserRepository(this._firestoreService);

  Future<int> getTotalUsers() async {
    return await _firestoreService.getTotalUsers();
  }

  Future<List<UserModel>> getRecentUsers(int limit) async {
    final data = await _firestoreService.getRecentUsers(limit);
    return data.map((e) => UserModel.fromMap(e, e['uid'])).toList();
  }

  Future<List<UserModel>> getAllUsers() async {
    final data = await _firestoreService.getAllUsers();
    return data.map((e) => UserModel.fromMap(e, e['uid'])).toList();
  }

  Future<Map<String, dynamic>> getUsersPaginated(
    int limit,
    DocumentSnapshot? lastDocument,
  ) async {
    final result = await _firestoreService.getUsersPaginated(
      limit,
      lastDocument,
    );
    final users =
        (result['users'] as List)
            .map((e) => UserModel.fromMap(e, e['uid']))
            .toList();
    return {'users': users, 'lastDocument': result['lastDocument']};
  }

  Future<void> deleteUser(String uid) async {
    await _firestoreService.deleteUser(uid);
  }
}
