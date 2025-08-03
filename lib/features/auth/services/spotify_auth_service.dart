import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:moodsic/core/config/env.dart';
import '../../shared/services/spotify_auth.dart';

class SpotifyAuthService {
  final SpotifyAuth _spotifyAuth = SpotifyAuth();

  Future<String?> signInWithSpotify() async {
    try {
      // Bước 1: Lấy accessToken và refreshToken từ Spotify
      final tokenMap = await _spotifyAuth.authenticate();
      if (tokenMap == null) return null;
      print(tokenMap);

      final accessToken = tokenMap['accessToken'];
      final refreshToken = tokenMap['refreshToken'];

      final expiredIn = tokenMap['expiredIn'];
      print('EXPIRED ${expiredIn}');
      final DateTime expiredAt = DateTime.now().add(
        Duration(seconds: (expiredIn)),
      );

      // Bước 2: Gửi accessToken lên backend để nhận Firebase token
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
        return null;
      }

      final backendData = jsonDecode(backendResponse.body);
      final firebaseToken = backendData['firebaseToken'];

      if (firebaseToken == null) return null;

      // Đăng nhập Firebase
      await FirebaseAuth.instance.signInWithCustomToken(firebaseToken);
      print("Signed in with Firebase custom token");

      return firebaseToken;
    } catch (e) {
      print('SpotifyAuthService Error: $e');
      return null;
    }
  }
}
