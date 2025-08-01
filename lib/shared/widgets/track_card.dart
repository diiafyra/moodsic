import 'package:flutter/material.dart';
import 'package:moodsic/core/widgets/add_btn.dart';
import 'package:moodsic/domains/usecases/playlist/handle_add_playlist.dart';
import '../../core/config/theme/app_colors.dart';

class TrackCard extends StatelessWidget {
  final String id;
  final String title;
  final String? url;
  final List<String> artists;

  const TrackCard({
    super.key,
    required this.id,
    required this.title,
    this.url,
    required this.artists,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          // Ảnh bài hát hoặc fallback
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child:
                url != null
                    ? Image.network(
                      url!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _fallbackImage();
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return _loadingImage();
                      },
                    )
                    : _fallbackImage(),
          ),
          const SizedBox(width: 12),

          // Thông tin bài hát
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Recursive',
                    fontSize: 18,
                    fontVariations: [
                      FontVariation('wght', 500),
                      FontVariation('MONO', 0),
                      FontVariation('CASL', 0),
                    ],
                    color: AppColors.oceanBlue50,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  artists.join(', '),
                  style: const TextStyle(
                    fontFamily: 'Recursive',
                    fontSize: 12,
                    fontVariations: [
                      FontVariation('MONO', 0),
                      FontVariation('CASL', 0),
                    ],
                    color: Color(0xFFB6CBDC),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Nút Add được tách ra
          AddButton(onPressed: () => handleAddPlaylist(id)),
        ],
      ),
    );
  }

  Widget _fallbackImage() => Container(
    width: 50,
    height: 50,
    color: Colors.white38,
    child: const Icon(Icons.music_note, color: Colors.white),
  );

  Widget _loadingImage() => Container(
    width: 50,
    height: 50,
    color: Colors.white12,
    child: const Center(
      child: SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    ),
  );
}
