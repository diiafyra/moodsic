import 'package:flutter/material.dart';
import 'package:moodsic/core/config/theme/app_colors.dart';
import 'package:moodsic/features/playlist_suggestion/viewmodel/playlist_viewmodel.dart';
import 'package:moodsic/samples/samplePlaylists.dart';
import 'package:moodsic/shared/widgets/mood_painter/mood_canvas_painter_widget.dart';
import 'package:moodsic/features/playlist_suggestion/widgets/playlist_content.dart';
import 'package:moodsic/data/models/playlist_model.dart';
import 'package:moodsic/shared/widgets/track_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  List<PlaylistModel> recommendedPlaylists = [];
  final GlobalKey _playlistKey = GlobalKey();
  final GlobalKey _playlistHeaderKey = GlobalKey();

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  double canvasWidth = 400;
  double canvasHeight = 500;

  void updatePlaylists(List<PlaylistModel> playlists) {
    setState(() {
      recommendedPlaylists = playlists;
    });

    // Start animations
    _fadeController.forward();
    _slideController.forward();

    // Delay để widget build xong rồi mới scroll
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_playlistHeaderKey.currentContext != null) {
        Scrollable.ensureVisible(
          _playlistHeaderKey.currentContext!,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  Widget _buildPlaylistHeaderWithKey() {
    return Container(
      key: _playlistHeaderKey, // ✅ Gắn key tại đây
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Icon và sparkles
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary400, AppColors.oceanBlue800],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary400.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.music_note_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text('✨', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              const Text('🎵', style: TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 16),

          // Title with gradient
          ShaderMask(
            shaderCallback:
                (bounds) => LinearGradient(
                  colors: [Colors.white, Colors.white.withOpacity(0.8)],
                ).createShader(bounds),
            child: Text(
              'Playlist dành riêng cho bạn',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),

          // Subtitle
          Text(
            'Dựa trên cảm xúc và sở thích của bạn',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Decorative line
          Container(
            height: 2,
            width: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.primary400,
                  Colors.transparent,
                ],
              ),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Moodsic say hi',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '૮ ․ ․ ྀིა',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Text(
                    'Hôm nay bạn đang cảm thấy thế nào?',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 28,
              backgroundImage: const NetworkImage(
                'https://i.pravatar.cc/100?img=10',
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.oceanBlue800,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final canvasWidthcal = constraints.maxWidth * 0.85;
          final canvasHeightcal = constraints.maxHeight * 0.45;
          canvasWidth = canvasWidthcal;
          canvasHeight = canvasHeightcal;

          return SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // Header với gradient background
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.oceanBlue800,
                        AppColors.oceanBlue800.withOpacity(0.95),
                      ],
                    ),
                  ),
                  child: SafeArea(child: _buildUserHeader()),
                ),

                const SizedBox(height: 8),

                // Canvas section
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: MoodCanvasPainterWidget(
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
                    onPlaylistsReceived: (playlists) {
                      debugPrint(
                        '📦 Đã nhận được ${playlists.length} playlist',
                      );
                      updatePlaylists(playlists);
                    },
                  ),
                ),

                const SizedBox(height: 32),

                // Playlist results với animation
                if (recommendedPlaylists.isNotEmpty)
                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          _buildPlaylistHeaderWithKey(),
                          PlaylistContent(
                            playlists:
                                recommendedPlaylists
                                    .map((p) => PlaylistViewModel(playlist: p))
                                    .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 60),
              ],
            ),
          );
        },
      ),
    );
  }
}
