import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moodsic/data/models/user.dart';
import 'package:moodsic/data/repositories/user_repository.dart';

class FetchAllUsersParams {
  final int limit;
  final DocumentSnapshot? startAfter;
  final String? role;
  final bool? isActive;
  final String? query;

  FetchAllUsersParams({
    this.limit = 10,
    this.startAfter,
    this.role,
    this.isActive,
    this.query,
  });
}

class FetchAllUsers {
  final UserRepository _userRepository;

  FetchAllUsers(this._userRepository);

  Future<List<UserModel>> execute() async {
    return await _userRepository.getAllUsers();
  }

  Future<Map<String, dynamic>> executePaginated(
    int limit,
    DocumentSnapshot? lastDocument,
  ) async {
    return await _userRepository.getUsersPaginated(limit, lastDocument);
  }
}
