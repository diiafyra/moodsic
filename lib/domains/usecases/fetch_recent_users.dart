import 'package:moodsic/data/models/user.dart';
import 'package:moodsic/data/repositories/user_repository.dart';

class FetchRecentUsers {
  final UserRepository _userRepository;

  FetchRecentUsers(this._userRepository);

  Future<List<UserModel>> execute(int limit) async {
    return await _userRepository.getRecentUsers(limit);
  }
}
