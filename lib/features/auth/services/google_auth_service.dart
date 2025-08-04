import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moodsic/shared/states/auth_provider.dart';

class GoogleAuthService {
  final _googleSignIn = GoogleSignIn.instance;
  final _auth = FirebaseAuth.instance;

  Future<User?> signInWithGoogle() async {
    try {
      CAuthProvider.instance.setAuthenticating(true);

      await _googleSignIn.initialize();

      final googleAccount = await _googleSignIn.authenticate();
      if (googleAccount == null) {
        CAuthProvider.instance.setAuthenticating(false);
        return null;
      }

      final googleAuth = googleAccount.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.idToken,
        idToken: googleAuth.idToken,
      );

      final userCred = await _auth.signInWithCredential(credential);

      // Refresh user state
      await CAuthProvider.instance.refreshUserState();

      return userCred.user;
    } catch (e) {
      print('GoogleAuthService Error: $e');
      CAuthProvider.instance.setAuthenticating(false);
      return null;
    }
  }
}
