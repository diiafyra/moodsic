import 'package:moodsic/data/repositories/user_repository.dart';

class DeleteUser {
  final UserRepository _userRepository;

  DeleteUser(this._userRepository);

  Future<void> execute(String uid) async {
    await _userRepository.deleteUser(uid);
  }
}
