import 'package:flutter/material.dart';
import 'package:moodsic/core/widgets/add_btn.dart';
import 'package:moodsic/core/widgets/like_btn.dart';
import 'package:moodsic/core/widgets/play_pause_btn.dart';
import 'package:moodsic/shared/widgets/track_card.dart';
import 'package:moodsic/shared/widgets/playlist_dto.dart';
import '../../core/widgets/search_bar.dart';
import '../../shared/widgets/playlist_card.dart';

class PlaylistContent extends StatelessWidget {
  final List<PlaylistDto> playlists;

  const PlaylistContent({super.key, required this.playlists});

  @override
  Widget build(BuildContext context) {
    final PlaylistDto mainPlaylist = playlists.firstWhere(
      (p) => p.isMain,
      orElse: () => playlists.first,
    );
    final List<PlaylistDto> otherPlaylists =
        playlists.where((p) => !p.isMain).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMainSection(mainPlaylist),
        _buildOtherPlaylists(otherPlaylists),
      ],
    );
  }

  Widget _buildMainSection(PlaylistDto mainPlaylist) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildArtistsInfo(mainPlaylist),
          _buildSearchBar(),
          const SizedBox(height: 16),
          _buildActionButtons(mainPlaylist),
          const SizedBox(height: 16),
          _buildTrackList(mainPlaylist),
        ],
      ),
    );
  }

  Widget _buildArtistsInfo(PlaylistDto playlist) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        "Gồm: ${playlist.artists.length > 3 ? playlist.artists.take(3).join(', ') + ',...' : playlist.artists.join(', ')}",
        style: const TextStyle(color: Colors.white70),
      ),
    );
  }

  Widget _buildSearchBar() {
    return CSearchBar(
      hintText: 'Tìm trong playlist',
      controller: TextEditingController(),
    );
  }

  Widget _buildActionButtons(PlaylistDto playlist) {
    return Row(
      children: [
        PlayPauseButton(
          id: playlist.id,
          size: 32,
          isPlaying: playlist.isPlaying,
        ),
        const SizedBox(width: 12),
        LikeButton(id: playlist.id, size: 32, isLiked: playlist.isLiked),
        const SizedBox(width: 6),

        AddButton(
          onPressed: () {
            print("Thêm bài hát vào playlist");
          },
          size: 32,
        ),
      ],
    );
  }

  Widget _buildTrackList(PlaylistDto playlist) {
    return Padding(
      padding: const EdgeInsets.only(right: 36),
      child: Column(
        children:
            playlist.tracks
                ?.map(
                  (track) => TrackCard(
                    id: track.id,
                    title: track.title,
                    url: track.url,
                    artists: track.artists,
                  ),
                )
                .toList() ??
            const [],
      ),
    );
  }

  Widget _buildOtherPlaylists(List<PlaylistDto> playlists) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: playlists.length,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 180,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 3 / 4,
        ),
        itemBuilder: (context, index) {
          final playlist = playlists[index];
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
        },
      ),
    );
  }
}
