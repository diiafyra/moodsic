import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moodsic/core/config/theme/app_colors.dart';
import 'package:moodsic/core/widgets/custom_network_image.dart';
import 'package:moodsic/core/widgets/like_btn.dart';
import 'package:moodsic/core/widgets/play_pause_btn.dart';
import 'package:moodsic/features/playlist_detail_page/pages/playlist_detail.dart';
import 'package:moodsic/features/playlist_suggestion/controller/play_controller.dart';
import 'package:moodsic/features/playlist_suggestion/viewmodel/playlist_viewmodel.dart';

class PlaylistCard extends StatefulWidget {
  final PlaylistViewModel model;

  const PlaylistCard({super.key, required this.model});

  @override
  State<PlaylistCard> createState() => _PlaylistCardState();
}

class _PlaylistCardState extends State<PlaylistCard> {
  @override
  void initState() {
    super.initState();
  }

  void _navigateToDetail() {
    // Chuẩn bị data cho PlaylistDetail
    final List<PlaylistViewModel> playlistsToPass = [widget.model];

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return PlaylistDetail(playlists: playlistsToPass);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Slide transition từ dưới lên (giống iOS)
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    final playlist = model.playlist;
    bool isPlaying = model.isPlaying;
    bool isLiked = model.isLiked;
    final formattedDate = DateFormat(
      'dd/MM/yyyy',
    ).format(playlist.createdDate ?? DateTime.now());
    final PlayController _playController = PlayController();

    return GestureDetector(
      onTap: _navigateToDetail, // Thêm onTap để navigate
      child: Container(
        width: 160,
        height: 212,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Nền màu
              Container(color: AppColors.primary50),

              CustomNetworkImage(
                imageUrl: model.imageUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),

              // Gradient trên
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.oceanBlue700,
                      AppColors.oceanBlue700.withOpacity(0.0),
                    ],
                    stops: [0.0, 56 / 212],
                  ),
                ),
              ),

              // Màu đặc phía dưới
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 56,
                child: Container(color: AppColors.oceanBlue700),
              ),

              // Artist
              Positioned(
                top: 4,
                left: 12,
                right: 28,
                height: 56,
                child: Padding(
                  padding: const EdgeInsets.only(right: 24, top: 8),
                  child: Text(
                    model.artists.length > 3
                        ? '${model.artists.take(3).join(', ')},...'
                        : model.artists.join(', '),
                    style: const TextStyle(
                      fontSize: 8,
                      color: AppColors.oceanBlue50,
                      fontFamily: 'Recursive',
                      fontVariations: [
                        FontVariation('wght', 400),
                        FontVariation('MONO', 1.0),
                      ],
                    ),
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              // Mô tả, ngày, tên
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 56,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 60, top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        model.description,
                        style: const TextStyle(
                          fontFamily: 'Recursive',
                          fontSize: 7,
                          color: AppColors.oceanBlue50,
                          fontVariations: [
                            FontVariation('wght', 700),
                            FontVariation('MONO', 1),
                            FontVariation('CASL', 1),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Ngày tạo: $formattedDate",
                        style: const TextStyle(
                          color: AppColors.oceanBlue50,
                          fontSize: 6,
                        ),
                      ),
                      if (model.name != null && model.name!.isNotEmpty)
                        Text(
                          "Tên: ${model.name}",
                          style: const TextStyle(
                            color: AppColors.oceanBlue50,
                            fontSize: 6,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ),

              // Nút Play/Pause
              Positioned(
                bottom: 24,
                right: 12,
                child: GestureDetector(
                  onTap: () {
                    // Ngăn không cho navigate khi tap vào play button
                  },
                  child: PlayPauseButton(
                    size: 24,
                    id: model.id,
                  ),
                ),
              ),

              // Nút Like
              Positioned(
                top: 8,
                right: 12,
                child: GestureDetector(
                  onTap: () {
                    // Ngăn không cho navigate khi tap vào like button
                  },
                  child: LikeButton(
                    model: model.playlist,
                    isLiked: isLiked,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
