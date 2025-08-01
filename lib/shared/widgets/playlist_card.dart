import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moodsic/core/config/theme/app_colors.dart';
import 'package:moodsic/core/widgets/custom_network_image.dart';
import 'package:moodsic/core/widgets/like_btn.dart';
import 'package:moodsic/core/widgets/play_pause_btn.dart';
import 'package:moodsic/domains/usecases/playlist/handle_like_playlist.dart';
import 'package:moodsic/domains/usecases/playlist/handle_play_playlist.dart';

class PlaylistCard extends StatefulWidget {
  final String id;
  final String? imageUrl;
  final String description;
  final String? name;
  final List<String> artists;
  final bool isPlaying;
  final bool isLiked;
  final DateTime? createdDate;

  const PlaylistCard({
    super.key,
    required this.id,
    this.imageUrl,
    required this.description,
    this.name,
    required this.artists,
    this.isPlaying = false,
    this.isLiked = false,
    this.createdDate,
  });

  @override
  State<PlaylistCard> createState() => _PlaylistCardState();
}

class _PlaylistCardState extends State<PlaylistCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isPlaying = widget.isPlaying;
    bool isLiked = widget.isLiked;
    final formattedDate = DateFormat(
      'dd/MM/yyyy',
    ).format(widget.createdDate ?? DateTime.now());

    return Container(
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
              imageUrl: widget.imageUrl,
              width: double.infinity, // hoặc chiều rộng bạn muốn
              height: double.infinity, // hoặc chiều cao bạn muốn
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
                  widget.artists.length > 3
                      ? '${widget.artists.take(3).join(', ')},...'
                      : widget.artists.join(', '),
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
                padding: const EdgeInsets.only(left: 12, right: 24, top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.description,
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
                    if (widget.name != null && widget.name!.isNotEmpty)
                      Text(
                        "Tên: ${widget.name}",
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
              child: PlayPauseButton(
                size: 24,
                id: widget.id,
                isPlaying: isPlaying,
              ),
            ),

            // Nút Like
            Positioned(
              top: 8,
              right: 12,
              child: LikeButton(id: widget.id, isLiked: isLiked, size: 24),
            ),
          ],
        ),
      ),
    );
  }
}
