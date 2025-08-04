import 'package:flutter/material.dart';
import 'package:moodsic/core/config/theme/app_colors.dart';
import 'package:moodsic/data/models/music_profle.dart';
import 'package:moodsic/features/profile/widgets/profile_section.dart';

class FavoriteArtistsWidget extends StatelessWidget {
  final MusicProfile musicProfile;

  const FavoriteArtistsWidget({super.key, required this.musicProfile});

  @override
  Widget build(BuildContext context) {
    if (musicProfile.artists?.isEmpty ?? true) return const SizedBox.shrink();

    return ProfileSection(
      title: 'NGHỆ SĨ YÊU THÍCH',
      child: Column(
        children:
            (musicProfile.artists?.map((artist) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.primary300,
                          backgroundImage:
                              artist.imageUrl != null
                                  ? NetworkImage(artist.imageUrl!)
                                  : null,
                          child:
                              artist.imageUrl == null
                                  ? const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 20,
                                  )
                                  : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                artist.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              if (artist.genre != null)
                                Text(
                                  artist.genre!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList() ??
                []),
      ),
    );
  }
}
