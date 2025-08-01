import 'package:flutter/material.dart';
import 'package:moodsic/core/config/theme/app_colors.dart';
import 'package:moodsic/mood_engine.dart';
import 'package:moodsic/shared/widgets/playlist_content.dart'; // <-- thêm dòng này
import 'package:moodsic/shared/widgets/playlist_dto.dart';
import 'package:moodsic/shared/widgets/track_dto.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.oceanBlue800,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final canvasWidth = constraints.maxWidth * 0.8;
          final canvasHeight = constraints.maxHeight * 0.5;

          // Phân tách main & others
          final mainPlaylist = _samplePlaylists.firstWhere(
            (p) => p.isMain == true,
          );
          final otherPlaylists =
              _samplePlaylists.where((p) => p.isMain == false).toList();

          return SingleChildScrollView(
            controller: _scrollController,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Moodsic say hi ૮ ․ ․ ྀིა',
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Hôm nay bạn đang cảm thấy thế nào?',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.white70),
                            ),
                          ],
                        ),
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(
                            'https://i.pravatar.cc/100?img=10', // hoặc Avatar người dùng
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  MoodCanvasPainterWidget(
                    canvasSize: Size(canvasWidth, canvasHeight),
                    moods: [
                      [AppColors.brickRed600, 'Happy', AppColors.primary400],
                      [AppColors.indigoNight800, 'Sad', AppColors.charcoal50],
                      [AppColors.charcoal600, 'Calm', AppColors.charcoal50],
                      [
                        AppColors.brickRed200,
                        'Energetic',
                        AppColors.indigoNight600,
                      ],
                    ],
                  ),
                  const SizedBox(height: 24),
                  PlaylistContent(playlists: _samplePlaylists),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  final List<PlaylistDto> _samplePlaylists = [
    PlaylistDto(
      id: '1',
      imageUrl: 'https://i.imgur.com/ZWLFD3m.jpeg',
      description: 'Playlist chính với các bài hát yêu thích.',
      name: 'Playlist Yêu Thích',
      artists: ['Artist 1', 'Artist 2', 'Artist 3'],
      isPlaying: false,
      isLiked: true,
      createdDate: DateTime(2025, 7, 29),
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
          title: 'Bài 3',
          url: 'https://via.placeholder.com/50',
          artists: ['Artist 3'],
        ),
      ],
      isMain: true,
    ),
    PlaylistDto(
      id: '2',
      imageUrl: 'https://via.placeholder.com/200',
      description: 'Playlist thư giãn cuối tuần.',
      name: 'Thư Giãn',
      artists: ['Artist A', 'Artist B'],
      isPlaying: false,
      isLiked: false,
      createdDate: DateTime(2025, 7, 29),
      tracks: null,
      isMain: false,
    ),
    PlaylistDto(
      id: '3',
      imageUrl: 'https://via.placeholder.com/200',
      description: 'Playlist tập thể dục.',
      name: 'Tập Luyện',
      artists: ['Artist X', 'Artist Y', 'Artist Z'],
      isPlaying: false,
      isLiked: true,
      createdDate: DateTime(2025, 7, 29),
      tracks: null,
      isMain: false,
    ),
  ];
}
