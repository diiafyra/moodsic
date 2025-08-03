import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:moodsic/core/config/env.dart';
import 'package:moodsic/data/models/playlist_model.dart';
import 'package:moodsic/samples/samplePlaylists.dart';
import 'package:moodsic/shared/widgets/track_dto.dart';

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

  static Future<List<TrackDto>> fetchTracksFromPlaylist({
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
        return result.map((trackJson) => TrackDto.fromJson(trackJson)).toList();
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
  static Future<List<TrackDto>> fetchAllTracksFromPlaylist({
    required String playlistId,
    int limit = 100,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (playlistId.isEmpty || uid == null || uid.isEmpty) {
      throw Exception('Missing playlistId or user not authenticated');
    }

    int offset = 0;
    bool hasNext = true;
    List<TrackDto> allTracks = [];

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
              .map((trackJson) => TrackDto.fromJson(trackJson))
              .toList();
      allTracks.addAll(tracks);
      hasNext = data['next'] != null;
      offset += limit;
    }

    return allTracks;
  }
}
