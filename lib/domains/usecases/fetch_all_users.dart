import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moodsic/data/models/user.dart';
import 'package:moodsic/data/repositories/user_repository.dart';

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
