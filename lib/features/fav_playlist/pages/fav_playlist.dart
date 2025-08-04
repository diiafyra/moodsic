import 'package:flutter/material.dart';
import 'package:moodsic/core/config/theme/app_colors.dart';
import 'package:moodsic/core/widgets/search_bar.dart';
import 'package:moodsic/core/services/firestore/firestore_service.dart';
import 'package:moodsic/features/playlist_suggestion/viewmodel/playlist_viewmodel.dart';
import 'package:get_it/get_it.dart';
import 'package:moodsic/shared/widgets/playlist_card.dart';

class FavPlaylistPage extends StatefulWidget {
  const FavPlaylistPage({super.key});

  @override
  State<FavPlaylistPage> createState() => _FavPlaylistPageState();
}

class _FavPlaylistPageState extends State<FavPlaylistPage> {
  final TextEditingController _searchController = TextEditingController();
  final FirestoreService _firestoreService = GetIt.instance<FirestoreService>();

  // Liked playlists
  List<PlaylistViewModel> _allLikedPlaylists = [];
  List<PlaylistViewModel> _filteredLikedPlaylists = [];

  // My playlists
  List<PlaylistViewModel> _allMyPlaylists = [];
  List<PlaylistViewModel> _filteredMyPlaylists = [];

  bool _isLoadingLiked = true;
  bool _isLoadingMy = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadAllPlaylists();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAllPlaylists() async {
    await Future.wait([_loadLikedPlaylists(), _loadMyPlaylists()]);
  }

  Future<void> _loadLikedPlaylists() async {
    try {
      setState(() {
        _isLoadingLiked = true;
        _errorMessage = '';
      });

      final likedPlaylists = await _firestoreService.getLikedPlaylists();

      final viewModels =
          likedPlaylists.map((playlist) {
            return PlaylistViewModel(
              playlist: playlist,
              isLiked: true,
              isPlaying: false,
            );
          }).toList();

      setState(() {
        _allLikedPlaylists = viewModels;
        _filteredLikedPlaylists = viewModels;
        _isLoadingLiked = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi khi tải playlist yêu thích: $e';
        _isLoadingLiked = false;
      });
    }
  }

  Future<void> _loadMyPlaylists() async {
    try {
      setState(() {
        _isLoadingMy = true;
        _errorMessage = '';
      });

      final myPlaylists = await _firestoreService.getMyPlaylists();

      final viewModels =
          myPlaylists.map((playlist) {
            return PlaylistViewModel(
              playlist: playlist,
              isLiked: false, // Sẽ được xác định sau
              isPlaying: false,
            );
          }).toList();

      setState(() {
        _allMyPlaylists = viewModels;
        _filteredMyPlaylists = viewModels;
        _isLoadingMy = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi khi tải playlist của bạn: $e';
        _isLoadingMy = false;
      });
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredLikedPlaylists = _allLikedPlaylists;
        _filteredMyPlaylists = _allMyPlaylists;
      } else {
        _filteredLikedPlaylists =
            _allLikedPlaylists.where((playlist) {
              return playlist.name?.toLowerCase().contains(query) == true ||
                  playlist.description.toLowerCase().contains(query) ||
                  playlist.artists.any(
                    (artist) => artist.toLowerCase().contains(query),
                  );
            }).toList();

        _filteredMyPlaylists =
            _allMyPlaylists.where((playlist) {
              return playlist.name?.toLowerCase().contains(query) == true ||
                  playlist.description.toLowerCase().contains(query) ||
                  playlist.artists.any(
                    (artist) => artist.toLowerCase().contains(query),
                  );
            }).toList();
      }
    });
  }

  Future<void> _onRefresh() async {
    await _loadAllPlaylists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.oceanBlue900,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.oceanBlue800,
              AppColors.oceanBlue900,
              AppColors.indigoNight950,
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildSearchBar(),
              Expanded(child: _buildContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final totalPlaylists = _allLikedPlaylists.length + _allMyPlaylists.length;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Thư Viện Playlist',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.oceanBlue50,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$totalPlaylists playlist tổng cộng',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.oceanBlue300,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.oceanBlue700.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              onPressed: _onRefresh,
              icon: const Icon(Icons.refresh, color: AppColors.oceanBlue200),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: CSearchBar(
        hintText: 'Tìm kiếm playlist...',
        controller: _searchController,
        onChanged: (_) => _onSearchChanged(),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoadingLiked || _isLoadingMy) {
      return _buildLoadingState();
    }

    if (_errorMessage.isNotEmpty) {
      return _buildErrorState();
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      backgroundColor: AppColors.oceanBlue800,
      color: AppColors.primary500,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLikedPlaylistsSection(),
            const SizedBox(height: 32),
            _buildMyPlaylistsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildLikedPlaylistsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          title: 'Playlist Yêu Thích',
          count: _filteredLikedPlaylists.length,
          icon: Icons.favorite,
        ),
        const SizedBox(height: 16),
        if (_filteredLikedPlaylists.isEmpty)
          _buildEmptySection('Chưa có playlist yêu thích nào')
        else
          _buildPlaylistGrid(_filteredLikedPlaylists),
      ],
    );
  }

  Widget _buildMyPlaylistsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          title: 'Playlist Của Bạn',
          count: _filteredMyPlaylists.length,
          icon: Icons.library_music,
        ),
        const SizedBox(height: 16),
        if (_filteredMyPlaylists.isEmpty)
          _buildEmptySection('Chưa có playlist nào được tạo')
        else
          _buildPlaylistGrid(_filteredMyPlaylists),
      ],
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required int count,
    required IconData icon,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary500.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary500, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.oceanBlue50,
                ),
              ),
              Text(
                '$count playlist',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.oceanBlue400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptySection(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.oceanBlue800.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.oceanBlue700.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Icon(Icons.music_note, size: 48, color: AppColors.oceanBlue400),
          const SizedBox(height: 12),
          Text(
            message,
            style: const TextStyle(color: AppColors.oceanBlue300, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylistGrid(List<PlaylistViewModel> playlists) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 160 / 212,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: playlists.length,
      itemBuilder: (context, index) {
        return PlaylistCard(model: playlists[index]);
      },
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary500),
          ),
          SizedBox(height: 16),
          Text(
            'Đang tải playlist...',
            style: TextStyle(color: AppColors.oceanBlue300, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.brickRed500.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.brickRed500.withOpacity(0.3),
                ),
              ),
              child: const Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.brickRed500,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.oceanBlue200,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadAllPlaylists,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary500,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }
}
