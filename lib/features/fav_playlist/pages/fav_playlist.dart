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
  List<PlaylistViewModel> _allPlaylists = [];
  List<PlaylistViewModel> _filteredPlaylists = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadLikedPlaylists();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadLikedPlaylists() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final likedPlaylists = await _firestoreService.getLikedPlaylists();

      // Convert PlaylistModel to PlaylistViewModel
      final viewModels =
          likedPlaylists.map((playlist) {
            return PlaylistViewModel(
              playlist: playlist,
              isLiked: true, // Tất cả đều đã được like
              isPlaying: false, // Mặc định không đang phát
            );
          }).toList();

      setState(() {
        _allPlaylists = viewModels;
        _filteredPlaylists = viewModels;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi khi tải danh sách: $e';
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredPlaylists = _allPlaylists;
      } else {
        _filteredPlaylists =
            _allPlaylists.where((playlist) {
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
    await _loadLikedPlaylists();
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
                  'Playlist Yêu Thích',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.oceanBlue50,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_allPlaylists.length} playlist',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.oceanBlue300,
                  ),
                ),
              ],
            ),
          ),
          // Refresh button
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
        hintText: 'Tìm kiếm playlist yêu thích...',
        controller: _searchController,
        onChanged: (_) => _onSearchChanged(),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_errorMessage.isNotEmpty) {
      return _buildErrorState();
    }

    if (_allPlaylists.isEmpty) {
      return _buildEmptyState();
    }

    if (_filteredPlaylists.isEmpty) {
      return _buildNoResultsState();
    }

    return _buildPlaylistGrid();
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
            'Đang tải playlist yêu thích...',
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
              onPressed: _loadLikedPlaylists,
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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.oceanBlue700.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.oceanBlue600.withOpacity(0.5),
                ),
              ),
              child: const Icon(
                Icons.favorite_border,
                size: 64,
                color: AppColors.oceanBlue400,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Chưa có playlist yêu thích',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.oceanBlue200,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Hãy thêm những playlist bạn yêu thích\nvào danh sách để dễ dàng tìm lại!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.oceanBlue400,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.oceanBlue700.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.search_off,
                size: 48,
                color: AppColors.oceanBlue400,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Không tìm thấy playlist nào',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.oceanBlue200,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Không có playlist nào khớp với từ khóa "${_searchController.text}"',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.oceanBlue400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaylistGrid() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      backgroundColor: AppColors.oceanBlue800,
      color: AppColors.primary500,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 160 / 212,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: _filteredPlaylists.length,
          itemBuilder: (context, index) {
            return PlaylistCard(model: _filteredPlaylists[index]);
          },
        ),
      ),
    );
  }
}
