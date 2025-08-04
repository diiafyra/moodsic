import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:moodsic/core/config/env.dart';
import 'package:moodsic/data/models/artist/artist.dart';
import 'package:moodsic/data/models/playlist_model.dart';
import 'package:moodsic/data/models/track.dart';
import 'package:moodsic/samples/samplePlaylists.dart';
import 'package:moodsic/shared/widgets/track_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  /// Gợi ý playlist từ ảnh và mood
  static Future<List<PlaylistModel>> recommendPlaylists({
    required File canvasImage,
    required String moodText,
    required double valence,
    required double arousal,
    required String uid,
  }) async {
    debugPrint('call tới recommend');
    final uri = Uri.parse('${Env.baseUrl}/recommend');

    final request = http.MultipartRequest('POST', uri);

    final canvasStream = http.ByteStream(canvasImage.openRead());
    final canvasLength = await canvasImage.length();
    final canvasPart = http.MultipartFile(
      'image',
      canvasStream,
      canvasLength,
      filename: canvasImage.path.split('/').last,
    );
    request.files.add(canvasPart);

    request.fields['uid'] = uid;
    request.fields['moodText'] = moodText;
    request.fields['circumplex'] = jsonEncode({
      'valence': valence,
      'arousal': arousal,
    });

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> playlistsJson = data['playlists'];
        debugPrint('result ${playlistsJson}');
        return playlistsJson
            .where((e) => e['playlist'] != null)
            .map((e) => PlaylistModel.fromJson(e['playlist']))
            .toList();
      } else {
        debugPrint(
          '❌ Recommend failed: ${response.statusCode} - ${response.body}',
        );
        return samplePlaylists;
      }
    } catch (e) {
      debugPrint('❌ Recommend exception: $e');
      return samplePlaylists;
    }
  }

  static Future<List<TrackViewmodel>> fetchTracksFromPlaylist({
    required String playlistId,
    int limit = 100,
    int offset = 0,
  }) async {
    debugPrint('fetch track call');

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (playlistId.isEmpty || uid == null || uid.isEmpty) {
      throw Exception('Missing playlistId or user not authenticated');
    }

    final url = '${Env.baseUrl}/spotify/fetchTracksFromPlaylist';
    debugPrint('uid: ${uid}');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'playlistId': playlistId,
          'uid': uid,
          'limit': limit,
          'offset': offset,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final result = data['result'] as List<dynamic>;
        debugPrint('result track: ${result}');
        return result
            .map((trackJson) => TrackViewmodel.fromJson(trackJson))
            .toList();
      } else {
        debugPrint(
          '❌ FetchTracks failed: ${response.statusCode} - ${response.body}',
        );
        return sampleTracks;
      }
    } catch (e) {
      debugPrint('❌ FetchTracks exception: $e');
      return sampleTracks;
    }
  }

  // Hàm lấy toàn bộ tracks (nếu cần)
  static Future<List<TrackViewmodel>> fetchAllTracksFromPlaylist({
    required String playlistId,
    int limit = 100,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (playlistId.isEmpty || uid == null || uid.isEmpty) {
      throw Exception('Missing playlistId or user not authenticated');
    }

    int offset = 0;
    bool hasNext = true;
    List<TrackViewmodel> allTracks = [];

    while (hasNext) {
      final response = await http.post(
        Uri.parse('${Env.baseUrl}/fetchTracksFromPlaylist'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'playlistId': playlistId,
          'uid': uid,
          'limit': limit,
          'offset': offset,
        }),
      );

      if (response.statusCode != 200) {
        print('⚠️ Fallback: ${response.statusCode} ${response.body}');
        return allTracks.isNotEmpty ? allTracks : sampleTracks;
      }

      final data = json.decode(response.body);
      final tracks =
          (data['result'] as List<dynamic>)
              .map((trackJson) => TrackViewmodel.fromJson(trackJson))
              .toList();
      allTracks.addAll(tracks);
      hasNext = data['next'] != null;
      offset += limit;
    }

    return allTracks;
  }

  static Future<List<Artist>> searchArtists(String keyword) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    try {
      final response = await http.post(
        Uri.parse('${Env.baseUrl}/spotify/search-artists'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'keyword': keyword, 'uid': uid}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> artistsJson = data['artists'] ?? [];
        debugPrint('result artist: ${artistsJson}');
        return artistsJson.map((json) => Artist.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search artists: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching artists: $e');
    }
  }

  static Future<List<TrackViewmodel>> searchTracks(String keyword) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    try {
      final response = await http.post(
        Uri.parse('${Env.baseUrl}/spotify/search-tracks'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'keyword': keyword, 'uid': uid}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> tracksJson = data['tracks'] ?? [];
        debugPrint('result track: ${tracksJson}');
        final trackList =
            tracksJson.map((json) => TrackViewmodel.fromJson(json)).toList();

        debugPrint(
          'result track map: ${trackList.map((t) => t.toString()).join('\n')}',
        );

        return trackList;
      } else {
        throw Exception('Failed to search tracks: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching tracks: $e');
    }
  }

  // Lấy deviceid đang hoạt động va lưu vào shared preferences
  static Future<String?> getActiveDeviceId() async {
    print("getActiveDeviceId()");
    // Lấy access_token từ firestore
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    if (accessToken == null) {
      throw Exception('Access token không tồn tại');
    }

    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/me/player/devices'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      print("getActiveDeviceId()>200");
      final json = jsonDecode(response.body);
      final devices = json['devices'] as List;
      print("devices");

      // Chọn thiết bị đang hoạt động nếu có
      final activeDevice = devices.firstWhere(
        (d) => d['is_active'] == true,
        orElse: () => devices.isNotEmpty ? devices.first : null,
      );

      print("device_id");
      prefs.setString('device_id', activeDevice['id']);
      print(prefs.getString('device_id'));

      return activeDevice?['id'];
    } else {
      print('Lỗi lấy device list: ${response.body}');
      return null;
    }
  }

  // Hàm phát playlist
  static Future<void> playPlaylist(String playlistId) async {
    print('playPlaylist()');
    final prefs = await SharedPreferences.getInstance();
    String deviceId = prefs.getString('device_id') ?? '';
    if (deviceId.isEmpty) {
      print("⚠️ Không tìm thấy device_id");
      return;
    }
    print('playlistId: $playlistId');
    print('deviceId: $deviceId');

    final accessToken = prefs.getString('access_token');
    if (accessToken == null) {
      print("⚠️ Không tìm thấy access_token");
      return;
    }

    final url = 'https://api.spotify.com/v1/me/player/play?device_id=$deviceId';

    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${accessToken}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"context_uri": "spotify:playlist:$playlistId"}),
    );

    if (response.statusCode != 204) {
      print('❌ Lỗi phát playlist: ${response.body}');
    }
  }

  // Hàm tạm dừng phát nhạc
  static Future<void> pausePlayback() async {
    print('pausePlayback()');
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    if (accessToken == null) {
      print("⚠️ Không tìm thấy access_token");
      return;
    }
    final url = 'https://api.spotify.com/v1/me/player/pause';
    final response = await http.put(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer ${accessToken}'},
    );

    if (response.statusCode != 204) {
      print('❌ Lỗi dừng nhạc: ${response.body}');
    }
  }

}
