import 'package:flutter/material.dart';
import 'package:moodsic/core/config/theme/app_colors.dart';
import 'package:moodsic/core/widgets/happy_button.dart';
import 'package:moodsic/core/widgets/sad_button.dart';
import 'package:moodsic/core/widgets/scroll_to_top_button.dart';
import 'package:moodsic/features/playlist_suggestion/viewmodel/playlist_viewmodel.dart';
import 'package:moodsic/features/playlist_suggestion/widgets/playlist_content.dart';

class PlaylistDetail extends StatefulWidget {
  final List<PlaylistViewModel> playlists;

  const PlaylistDetail({super.key, required this.playlists});

  @override
  State<PlaylistDetail> createState() => _PlaylistDetailState();
}

class _PlaylistDetailState extends State<PlaylistDetail> {
  late PlaylistViewModel mainPlaylist;
  late List<PlaylistViewModel> otherPlaylists;
  late bool isLiked;
  late bool isPlaying;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    mainPlaylist = widget.playlists.firstWhere(
      (p) => p.playlist.isMain,
      orElse: () => widget.playlists.first,
    );
    otherPlaylists = widget.playlists.where((p) => !p.playlist.isMain).toList();
    isLiked = mainPlaylist.isLiked;
    isPlaying = mainPlaylist.isPlaying;
  }

  void onToggleLike(bool newState) {
    setState(() => isLiked = newState);
  }

  void onTogglePlay(bool newState) {
    setState(() => isPlaying = newState);
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.oceanBlue800,
      body: Stack(children: [_buildScrollView(), _buildStickyButtons()]),
    );
  }

  Widget _buildScrollView() {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        _buildAppBar(),
        SliverToBoxAdapter(child: PlaylistContent(playlists: widget.playlists)),
      ],
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: const Color.fromARGB(0, 228, 81, 81),
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
            Image.network(
              mainPlaylist.imageUrl ?? '',
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    color: Colors.blueGrey.shade100,
                    alignment: Alignment.center,
                    child: const Icon(Icons.music_note, size: 40),
                  ),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.oceanBlue800, Colors.transparent],
                  stops: [0.0, 0.7],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStickyButtons() {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HappyButton(onTap: () => print("Clicked Happy Button")),
            const SizedBox(height: 16),
            SadButton(onTap: () => print("Clicked Sad Button")),
            const SizedBox(height: 16),
            ScrollToTopButton(onTap: _scrollToTop),
          ],
        ),
      ),
    );
  }
}
