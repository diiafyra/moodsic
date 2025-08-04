import 'package:flutter/material.dart';
import 'package:moodsic/core/config/theme/app_colors.dart';
import 'package:moodsic/data/models/music_profle.dart';
import 'package:moodsic/features/profile/widgets/profile_section.dart';

class MusicPreferencesWidget extends StatelessWidget {
  final MusicProfile musicProfile;

  const MusicPreferencesWidget({super.key, required this.musicProfile});

  @override
  Widget build(BuildContext context) {
    if (musicProfile.genres?.isEmpty ?? true) return const SizedBox.shrink();

    return ProfileSection(
      title: 'DÒNG NHẠC YÊU THÍCH',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children:
            (musicProfile.genres ?? []).map((genre) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary300.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary300, width: 1),
                ),
                child: Text(
                  genre,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
