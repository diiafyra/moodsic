import 'package:moodsic/data/repositories/user_repository.dart';

class FetchTotalUsers {
  final UserRepository _userRepository;

  FetchTotalUsers(this._userRepository);

  Future<int> execute() async {
    return await _userRepository.getTotalUsers();
  }
}
