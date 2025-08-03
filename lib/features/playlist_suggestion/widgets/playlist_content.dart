import 'package:flutter/material.dart';
import 'package:moodsic/core/widgets/add_btn.dart';
import 'package:moodsic/core/widgets/like_btn.dart';
import 'package:moodsic/core/widgets/play_pause_btn.dart';
import 'package:moodsic/features/playlist_suggestion/viewmodel/playlist_viewmodel.dart';
import 'package:moodsic/shared/widgets/track_card.dart';
import '../../../core/widgets/search_bar.dart';
import '../../../shared/widgets/playlist_card.dart';

class PlaylistContent extends StatefulWidget {
  final List<PlaylistViewModel> playlists;

  const PlaylistContent({super.key, required this.playlists});

  @override
  State<PlaylistContent> createState() => _PlaylistContentState();
}

class _PlaylistContentState extends State<PlaylistContent> {
  late final PlaylistViewModel mainPlaylist;
  late final List<PlaylistViewModel> otherPlaylists;

  int _visibleTrackCount = 20;

  @override
  void initState() {
    super.initState();
    mainPlaylist = widget.playlists.firstWhere(
      (p) => p.playlist.isMain,
      orElse: () => widget.playlists.first,
    );
    otherPlaylists = widget.playlists.where((p) => p != mainPlaylist).toList();

    mainPlaylist.fetchTracks().then((_) {
      setState(() {});
    });
  }

  void _loadMoreTracks() {
    setState(() {
      _visibleTrackCount += 20;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMainSection(mainPlaylist),
        _buildOtherPlaylists(otherPlaylists),
      ],
    );
  }

  Widget _buildMainSection(PlaylistViewModel playlist) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildArtistsInfo(playlist),
          _buildSearchBar(),
          const SizedBox(height: 16),
          _buildActionButtons(playlist),
          const SizedBox(height: 16),
          _buildTrackList(playlist),
        ],
      ),
    );
  }

  Widget _buildArtistsInfo(PlaylistViewModel playlist) {
    final artists =
        playlist.artists.length > 3
            ? '${playlist.artists.take(3).join(', ')},...'
            : playlist.artists.join(', ');

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        'Gồm: $artists',
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

  Widget _buildActionButtons(PlaylistViewModel playlist) {
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
          onPressed: () => print('Thêm bài hát vào playlist'),
          size: 32,
        ),
      ],
    );
  }

  Widget _buildTrackList(PlaylistViewModel playlist) {
    final visibleTracks = playlist.tracks.take(_visibleTrackCount).toList();

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: visibleTracks.length,
          itemBuilder: (context, index) {
            final track = visibleTracks[index];
            return TrackCard(
              id: track.id,
              title: track.name,
              url: track.imageUrl,
              artists: [track.artist ?? 'Unknown Artist'],
            );
          },
        ),
        if (_visibleTrackCount < playlist.tracks.length)
          Center(
            child: TextButton.icon(
              onPressed: _loadMoreTracks,
              icon: const Icon(Icons.keyboard_arrow_down),
              label: const Text('Xem thêm'),
              style: TextButton.styleFrom(foregroundColor: Colors.white70),
            ),
          ),
        if (playlist.isLoading)
          const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }

  Widget _buildOtherPlaylists(List<PlaylistViewModel> playlists) {
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
            createdDate: playlist.playlist.createdDate,
          );
        },
      ),
    );
  }
}
