// features/create_playlist/widgets/create_playlist_button.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:moodsic/core/config/theme/app_colors.dart';

class CreatePlaylistButton extends StatelessWidget {
  final int trackCount;
  final VoidCallback onPressed;

  const CreatePlaylistButton({
    super.key,
    required this.trackCount,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            AppColors.indigoNight950.withOpacity(0.8),
            AppColors.indigoNight950,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: GestureDetector(
          onTap: trackCount > 0 ? onPressed : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 56,
            decoration: BoxDecoration(
              gradient:
                  trackCount > 0
                      ? LinearGradient(
                        colors: [AppColors.brickRed500, AppColors.brickRed600],
                      )
                      : LinearGradient(
                        colors: [AppColors.charcoal600, AppColors.charcoal700],
                      ),
              borderRadius: BorderRadius.circular(16),
              boxShadow:
                  trackCount > 0
                      ? [
                        BoxShadow(
                          color: AppColors.brickRed500.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                      : null,
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.playlist_add_rounded,
                    color:
                        trackCount > 0 ? Colors.white : AppColors.charcoal400,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    trackCount > 0
                        ? 'Tạo Playlist ($trackCount bài)'
                        : 'Chọn bài hát để tạo playlist',
                    style: TextStyle(
                      color:
                          trackCount > 0 ? Colors.white : AppColors.charcoal400,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
