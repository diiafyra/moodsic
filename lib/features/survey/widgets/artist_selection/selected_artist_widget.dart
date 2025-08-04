import 'package:flutter/material.dart';
import '../../viewmodels/artist_viewmodel.dart';

class SelectedArtistsWidget extends StatelessWidget {
  final List<ArtistViewmodel> selectedArtists;
  final Function(ArtistViewmodel) onArtistRemove;

  const SelectedArtistsWidget({
    super.key,
    required this.selectedArtists,
    required this.onArtistRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedArtists.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 70, // Chiều cao giảm xuống
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: selectedArtists.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final artist = selectedArtists[index];
          return SizedBox(
            width: 60, // Width cố định cho avatar
            child: Stack(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 30,
                  backgroundImage:
                      artist.imageUrl != null
                          ? NetworkImage(artist.imageUrl!)
                          : null,
                  backgroundColor: const Color.fromARGB(255, 19, 73, 81),
                  child:
                      artist.imageUrl == null
                          ? const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 24,
                          )
                          : null,
                ),

                // Nút close đè lên góc phải của avatar
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => onArtistRemove(artist),
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
