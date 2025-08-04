import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moodsic/core/config/theme/app_colors.dart';
import 'package:moodsic/data/models/music_profle.dart';
import 'package:moodsic/shared/states/auth_provider.dart';

class SpotifyConnectionWidget extends StatelessWidget {
  final CAuthProvider authProvider;
  final MusicProfile? musicProfile;
  final VoidCallback onConnect;

  const SpotifyConnectionWidget({
    super.key,
    required this.authProvider,
    required this.musicProfile,
    required this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    final hasConnectedSpotify = authProvider.hasConnectedSpotify;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/spotify_icon.svg',
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  hasConnectedSpotify
                      ? AppColors.primary300
                      : Colors.white.withOpacity(0.5),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasConnectedSpotify
                          ? 'Đã liên kết tài khoản Spotify'
                          : 'Chưa liên kết Spotify',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      hasConnectedSpotify
                          ? 'Đã kết nối - Nhận gợi ý nhạc tốt hơn'
                          : 'Liên kết để có trải nghiệm tốt hơn',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              if (hasConnectedSpotify && musicProfile?.isActive == true)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Active',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          if (!hasConnectedSpotify) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary300,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: SvgPicture.asset(
                  'assets/icons/spotify_icon.svg',
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                label: const Text(
                  'Kết nối với Spotify',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                onPressed: onConnect,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
