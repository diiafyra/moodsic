import 'package:flutter/material.dart';
import 'package:moodsic/core/config/theme/app_colors.dart';
import 'package:moodsic/data/models/music_profle.dart';
import 'package:moodsic/features/profile/widgets/profile_section.dart';

class FavoriteTracksWidget extends StatelessWidget {
  final MusicProfile musicProfile;

  const FavoriteTracksWidget({super.key, required this.musicProfile});

  @override
  Widget build(BuildContext context) {
    if (musicProfile.tracks?.isEmpty ?? true) return const SizedBox.shrink();

    return ProfileSection(
      title: 'TRACK YÊU THÍCH',
      child: Column(
        children:
            (musicProfile.tracks?.map((track) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppColors.primary300,
                          ),
                          child:
                              track.imageUrl != null
                                  ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      track.imageUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                                Icons.music_note,
                                                color: Colors.white,
                                              ),
                                    ),
                                  )
                                  : const Icon(
                                    Icons.music_note,
                                    color: Colors.white,
                                  ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                track.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${track.artist} • ${track.album}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
