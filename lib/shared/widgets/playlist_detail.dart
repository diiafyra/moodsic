import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled/core/config/theme/app_colors.dart';
import 'package:untitled/core/widgets/add_button.dart';
import 'package:untitled/core/widgets/custom_network_image.dart';
import 'package:untitled/core/widgets/like_btn.dart';
import 'package:untitled/core/widgets/overlay.dart';
import 'package:untitled/core/widgets/play_pause_btn.dart';
import 'package:untitled/domains/usecases/playlist/handle_like_playlist.dart';
import 'package:untitled/domains/usecases/playlist/handle_play_playlist.dart';
import 'package:untitled/shared/widgets/playlist_card.dart';
import 'package:untitled/shared/widgets/playlist_dto.dart';
import 'package:untitled/shared/widgets/track_card.dart';
import '../../core/widgets/search_bar.dart';

class PlaylistDetail extends StatefulWidget {
  final List<PlaylistDto> playlists;

  const PlaylistDetail({super.key, required this.playlists});

  @override
  State<PlaylistDetail> createState() => _PlaylistDetailState();
}

class _PlaylistDetailState extends State<PlaylistDetail> {
  late PlaylistDto mainPlaylist;
  late List<PlaylistDto> otherPlaylists;
  late bool isLiked;
  late bool isPlaying;

  @override
  void initState() {
    super.initState();
    mainPlaylist = widget.playlists.firstWhere(
      (p) => p.isMain,
      orElse: () => widget.playlists.first,
    );
    otherPlaylists = widget.playlists.where((p) => !p.isMain).toList();
    isLiked = mainPlaylist.isLiked;
    isPlaying = mainPlaylist.isPlaying;
  }

  void onToggleLike(bool newState) {
    setState(() {
      isLiked = newState;
    });
  }

  void onTogglePlay(bool newState) {
    setState(() {
      isPlaying = newState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.oceanBlue900,
      body: CustomScrollView(
        slivers: [
          // Ảnh nền
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              title: Text(
                mainPlaylist.name ?? 'Playlist gợi ý',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CustomNetworkImage(
                    imageUrl: mainPlaylist.imageUrl,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    fallback: Container(
                      color: Colors.blueGrey.shade100,
                      alignment: Alignment.center,
                      child: const Icon(Icons.music_note, size: 40),
                    ),
                  ),
                  const OverlayLayer(
                    color: Color.fromRGBO(0, 0, 0, 0.702),
                    borderRadius: BorderRadius.zero,
                  ),
                ],
              ),
            ),
          ),

          // Nội dung chính
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Danh sách nghệ sĩ
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      "Gồm: ${mainPlaylist.artists.length > 3 ? mainPlaylist.artists.take(3).join(', ') + ',...' : mainPlaylist.artists.join(', ')}",
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),

                  // Search bar
                  CSearchBar(
                    hintText: 'Tìm trong playlist',
                    controller: TextEditingController(),
                  ),

                  const SizedBox(height: 16),

                  // Nút Play, Like, Add
                  Padding(
                    padding: const EdgeInsets.symmetric(),
                    child: Row(
                      children: [
                        PlayPauseButton(
                          id: mainPlaylist.id,
                          isPlaying: isPlaying,
                          onTap: buildPlayHandler(
                            isPlaying: isPlaying,
                            onToggle: onTogglePlay,
                          ),
                        ),

                        const SizedBox(width: 12),
                        LikeButton(
                          id: mainPlaylist.id,
                          isLiked: isLiked,
                          onTap: buildLikeHandler(
                            isLiked: isLiked,
                            onToggle: onToggleLike,
                          ),
                        ),

                        AddButton(
                          onPressed: () {
                            // Xử lý thêm bài hát vào playlist
                            print("Thêm bài hát vào playlist");
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Danh sách bài hát
                  Padding(
                    padding: const EdgeInsets.only(right: 36),
                    child: Column(
                      children: [
                        if (mainPlaylist.tracks != null)
                          ...mainPlaylist.tracks!.map(
                            (track) => TrackCard(
                              id: track.id,
                              title: track.title,
                              url: track.url,
                              artists: track.artists,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Các playlist khác
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                final playlist = otherPlaylists[index];
                return PlaylistCard(
                  id: playlist.id,
                  imageUrl: playlist.imageUrl,
                  description: playlist.description,
                  name: playlist.name,
                  artists: playlist.artists,
                  isPlaying: playlist.isPlaying,
                  isLiked: playlist.isLiked,
                  createdDate: playlist.createdDate,
                );
              }, childCount: otherPlaylists.length),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 180,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 3 / 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
