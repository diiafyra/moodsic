import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:moodsic/core/config/env.dart';
import 'package:moodsic/shared/states/auth_provider.dart';
import '../../shared/services/spotify_auth.dart';

class SpotifyAuthService {
  final SpotifyAuth _spotifyAuth = SpotifyAuth();

  Future<String?> signInWithSpotify() async {
    try {
      // Set authenticating state
      CAuthProvider.instance.setAuthenticating(true);

      final tokenMap = await _spotifyAuth.authenticate();
      if (tokenMap == null) {
        CAuthProvider.instance.setAuthenticating(false);
        return null;
      }
      print(tokenMap);

      final accessToken = tokenMap['accessToken'];
      final refreshToken = tokenMap['refreshToken'];
      final expiredIn = tokenMap['expiredIn'];

      print('EXPIRED ${expiredIn}');
      final DateTime expiredAt = DateTime.now().add(
        Duration(seconds: (expiredIn)),
      );

      final backendResponse = await http.post(
        Uri.parse('${Env.baseUrl}/spotify/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'accessToken': accessToken,
          'refreshToken': refreshToken,
          'expiredAt': expiredAt.toIso8601String(),
        }),
      );

      if (backendResponse.statusCode != 200) {
        print('Backend error: ${backendResponse.body}');
        CAuthProvider.instance.setAuthenticating(false);
        return null;
      }

      final backendData = jsonDecode(backendResponse.body);
      final firebaseToken = backendData['firebaseToken'];

      if (firebaseToken == null) {
        CAuthProvider.instance.setAuthenticating(false);
        return null;
      }

      // Đăng nhập Firebase
      await FirebaseAuth.instance.signInWithCustomToken(firebaseToken);
      print("Signed in with Firefox custom token");

      // Refresh user state và wait cho nó hoàn thành
      await CAuthProvider.instance.refreshUserState();

      return firebaseToken;
    } catch (e) {
      print('SpotifyAuthService Error: $e');
      CAuthProvider.instance.setAuthenticating(false);
      return null;
    }
  }
}
