import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoogleAuthService {
  final _googleSignIn = GoogleSignIn.instance;
  final _auth = FirebaseAuth.instance;

  Future<User?> signInWithGoogle() async {
    await _googleSignIn.initialize();

    final googleAccount = await _googleSignIn.authenticate();
    if (googleAccount == null) return null; // user hủy

    final googleAuth = googleAccount.authentication; // synchronous now

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.idToken,
      idToken: googleAuth.idToken,
    );

    final userCred = await _auth.signInWithCredential(credential);
    return userCred.user;
  }
}
