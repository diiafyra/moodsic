import 'package:flutter/material.dart';
import 'package:untitled/core/config/theme/app_colors.dart';
import 'package:untitled/shared/widgets/playlist_detail.dart';
import 'package:untitled/shared/widgets/playlist_dto.dart';
import 'package:untitled/shared/widgets/track_dto.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Playlist App',
      theme: ThemeData(
        primaryColor: AppColors.oceanBlue500,
        scaffoldBackgroundColor: AppColors.defaultTheme,
        colorScheme: ColorScheme(
          primary: AppColors.oceanBlue500,
          secondary: AppColors.primary500,
          surface: AppColors.charcoal50,
          error: AppColors.brickRed600,
          onPrimary: AppColors.defaultTheme,
          onSecondary: AppColors.defaultTheme,
          onSurface: AppColors.charcoal900,
          onError: AppColors.defaultTheme,
          brightness: Brightness.light,
        ),
      ),
      home: PlaylistDetail(playlists: _samplePlaylists),
    );
  }
}

// Dữ liệu mẫu
List<PlaylistDto> _samplePlaylists = [
  PlaylistDto(
    id: '1',
    imageUrl: 'https://i.imgur.com/ZWLFD3m.jpeg',
    description: 'Playlist chính với các bài hát yêu thích.',
    name: 'Playlist Yêu Thích',
    artists: ['Artist 1', 'Artist 2', 'Artist 3'],
    isPlaying: false,
    isLiked: true,
    createdDate: DateTime(
      2025,
      7,
      29,
    ), // Sử dụng ngày cố định thay vì DateTime.now()
    tracks: [
      TrackDto(
        id: 't1',
        title: 'Bài 1',
        url: 'https://via.placeholder.com/50',
        artists: ['Artist 1'],
      ),
      TrackDto(
        id: 't2',
        title: 'Bài 2',
        url: 'https://via.placeholder.com/50',
        artists: ['Artist 2'],
      ),
      TrackDto(
        id: 't3',
        title: 'Bài 2',
        url: 'https://via.placeholder.com/50',
        artists: ['Artist 2'],
      ),

      TrackDto(
        id: 't3',
        title: 'Bài 2',
        url: 'https://via.placeholder.com/50',
        artists: ['Artist 2'],
      ),

      TrackDto(
        id: 't2',
        title: 'Bài 2',
        url: 'https://via.placeholder.com/50',
        artists: ['Artist 2'],
      ),

      TrackDto(
        id: 't2',
        title: 'Bài 2',
        url: 'https://via.placeholder.com/50',
        artists: ['Artist 2'],
      ),

      TrackDto(
        id: 't2',
        title: 'Bài 2',
        url: 'https://via.placeholder.com/50',
        artists: ['Artist 2'],
      ),

      TrackDto(
        id: 't2',
        title: 'Bài 2',
        url: 'https://via.placeholder.com/50',
        artists: ['Artist 2'],
      ),
    ],
    isMain: true,
  ),
  PlaylistDto(
    id: '2',
    imageUrl: 'https://via.placeholder.com/200',
    description: 'Playlist thư giãn cuối tuần.',
    // name: 'Thư Giãn',
    artists: ['Artist A', 'Artist B'],
    isPlaying: false,
    isLiked: false,
    createdDate: DateTime(2025, 7, 29), // Sử dụng ngày cố định
    tracks: null,
    isMain: false,
  ),
  PlaylistDto(
    id: '3',
    imageUrl: 'https://via.placeholder.com/200',
    description: 'Playlist tập thể dục.',
    // name: 'Tập Luyện',
    artists: ['Artist X', 'Artist Y', 'Artist Z'],
    isPlaying: false,
    isLiked: true,
    createdDate: DateTime(2025, 7, 29), // Sử dụng ngày cố định
    tracks: null,
    isMain: false,
  ),
];
