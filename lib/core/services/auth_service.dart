import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<bool> isSignedIn() async {
    return _auth.currentUser != null;
  }

  Future<String?> getUserRole() async {
    final tokenResult = await _auth.currentUser?.getIdTokenResult();
    return tokenResult?.claims?['role'] as String?;
  }
}
