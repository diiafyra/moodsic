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
  bool _isScrolled = false;

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

    // Listen to scroll để thay đổi style của back button
    _scrollController.addListener(() {
      final isScrolled = _scrollController.offset > 100;
      if (_isScrolled != isScrolled) {
        setState(() => _isScrolled = isScrolled);
      }
    });
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
      body: Stack(
        children: [
          _buildScrollView(),
          _buildStickyButtons(),
          _buildBackButton(), // Thêm back button
        ],
      ),
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
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false, // Tắt back button mặc định
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
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.oceanBlue800,
                    AppColors.indigoNight900.withOpacity(0.6),
                  ],
                  stops: [0.0, 0.7],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 16,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color:
              _isScrolled
                  ? Colors.black.withOpacity(0.7)
                  : Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
          border:
              _isScrolled
                  ? null
                  : Border.all(color: Colors.white.withOpacity(0.3), width: 1),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  key: ValueKey(_isScrolled),
                  color: Colors.white,
                  size: _isScrolled ? 20 : 18,
                ),
              ),
            ),
          ),
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
