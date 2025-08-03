import 'dart:convert';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:moodsic/core/config/env.dart';
import 'package:moodsic/features/shared/services/spotify_auth.dart';

class SpotifyConnectService {
  final SpotifyAuth _spotifyAuth = SpotifyAuth();

  Future<Map<String, dynamic>?> connectToSpotify() async {
    try {
      // Bước 1: Lấy accessToken, refreshToken và expires_in từ Spotify
      final tokenMap = await _spotifyAuth.authenticate();
      if (tokenMap == null) return null;

      final accessToken = tokenMap['accessToken'];
      final refreshToken = tokenMap['refreshToken'];
      final expiredIn = tokenMap['expiredIn'] as int;
      final DateTime expiredAt = DateTime.now().add(
        Duration(seconds: expiredIn),
      );

      // Bước 2: Lấy UID từ Firebase
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("Người dùng chưa đăng nhập Firebase");
        return null;
      }

      final uid = user.uid;

      // Bước 3: Gửi dữ liệu lên backend để connect Spotify account
      final response = await http.post(
        Uri.parse('${Env.baseUrl}/spotify/connect'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'uid': uid,
          'accessToken': accessToken,
          'refreshToken': refreshToken,
          'expiredAt': expiredAt.toIso8601String(),
        }),
      );

      if (response.statusCode != 200) {
        print("Lỗi backend: ${response.body}");
        return null;
      }

      final result = jsonDecode(response.body);
      print("Kết quả kết nối Spotify: $result");

      return result;
    } catch (e) {
      print("Lỗi SpotifyConnect: $e");
      return null;
    }
  }
}
