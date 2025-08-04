import 'dart:convert';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;

class SpotifyAuth {
  static const _clientId = '17cc8dffd25c4b5996e0a047c8c12f07';
  static const _clientSecret = 'c4e8e714cce74646a70f6e3bdc48fd60';
  static const _redirectUri = 'moodsic://callback';
  static const _scopes =
      'user-read-private user-read-email playlist-modify-public playlist-modify-private';

  Future<Map<String, dynamic>?> authenticate() async {
    print('SPOTIFYYYYY');

    final authUrl = Uri.https('accounts.spotify.com', '/authorize', {
      'response_type': 'code',
      'client_id': _clientId,
      'redirect_uri': _redirectUri,
      'scope': _scopes,
    });
    try {
      final result = await FlutterWebAuth2.authenticate(
        url: authUrl.toString(),
        callbackUrlScheme: "moodsic",
      );

      final code = Uri.parse(result).queryParameters['code'];
      if (code == null) return null;

      final response = await http.post(
        Uri.https('accounts.spotify.com', '/api/token'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$_clientId:$_clientSecret'))}',
        },
        body: {
          'grant_type': 'authorization_code',
          'code': code,
          'redirect_uri': _redirectUri,
        },
      );

      print('[Response:] ${response.body}');

      final tokenData = jsonDecode(response.body);
      final accessToken = tokenData['access_token'];
      final refreshToken = tokenData['refresh_token'];
      final expiredIn = tokenData['expires_in'];

      if (accessToken == null || refreshToken == null) return null;

      return {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'expiredIn': expiredIn,
      };
    } catch (e) {
      print('SpotifyAuth Error: $e');
      return null;
    }
  }
}
