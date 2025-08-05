import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moodsic/core/config/theme/app_colors.dart';
import 'package:moodsic/core/services/api_service.dart';
import 'package:moodsic/features/search/widgets/create_playlist_bottom.dart';
import 'package:moodsic/features/search/widgets/selected_track_display.dart';
import 'package:moodsic/features/survey/widgets/track_selection_widget.dart';
import 'package:moodsic/shared/widgets/track_viewmodel.dart';

class CreatePlaylistPage extends StatefulWidget {
  const CreatePlaylistPage({super.key});

  @override
  State<CreatePlaylistPage> createState() => _CreatePlaylistPageState();
}

class _CreatePlaylistPageState extends State<CreatePlaylistPage> {
  List<TrackViewmodel> selectedTracks = [];
  final ScrollController _scrollController = ScrollController();

  void _onSelectionChanged(List<TrackViewmodel> tracks) {
    setState(() {
      selectedTracks = tracks;
    });
  }

  void _onCreatePlaylist() {
    if (selectedTracks.isEmpty) return;

    _showCreatePlaylistDialog();
  }

  void _showCreatePlaylistDialog() {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.indigoNight900,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Tạo Playlist',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Nhập tên playlist',
                    hintStyle: TextStyle(
                      color: AppColors.oceanBlue300.withOpacity(0.7),
                    ),
                    filled: true,
                    fillColor: AppColors.indigoNight800,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '${selectedTracks.length} bài hát được chọn',
                  style: const TextStyle(
                    color: AppColors.oceanBlue300,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Hủy',
                  style: TextStyle(color: AppColors.oceanBlue300),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.trim().isNotEmpty) {
                    _createPlaylist(nameController.text.trim());
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brickRed500,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Tạo', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );
  }

  Future<void> _createPlaylist(String playlistName) async {
    try {
      final apiService = getIt<ApiService>();

      final success = await apiService.createPlaylistWithTracks(
        name: playlistName,
        tracks: selectedTracks,
      );

      if (!success) {
        throw Exception('Tạo playlist thất bại');
      }

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã tạo playlist "$playlistName" thành công!'),
            backgroundColor: AppColors.brickRed500,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi tạo playlist: $e'),
            backgroundColor: AppColors.brickRed600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.indigoNight950,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.indigoNight900, AppColors.indigoNight950],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tạo Playlist Mới',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Tìm kiếm và thêm bài hát không giới hạn',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.oceanBlue300,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Main content
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // Track selection widget (sử dụng component có sẵn)
                      TrackSelectionWidget(
                        onSelectionChanged: _onSelectionChanged,
                        maxSelection: 999999, // Không giới hạn
                        isCreatePlaylist: true,
                      ),

                      const SizedBox(height: 24),

                      // Selected tracks display
                      if (selectedTracks.isNotEmpty)
                        SelectedTracksDisplay(selectedTracks: selectedTracks),

                      const SizedBox(height: 100), // Space for bottom button
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // Floating create button
      bottomNavigationBar: CreatePlaylistButton(
        trackCount: selectedTracks.length,
        onPressed: _onCreatePlaylist,
      ),
    );
  }
}
