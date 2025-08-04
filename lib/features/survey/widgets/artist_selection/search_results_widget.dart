import 'package:flutter/material.dart';
import '../../viewmodels/artist_viewmodel.dart';

class SearchResultsWidget extends StatelessWidget {
  final bool isSearching;
  final List<ArtistViewmodel> searchResults;
  final Function(ArtistViewmodel) onArtistTap;

  const SearchResultsWidget({
    super.key,
    required this.isSearching,
    required this.searchResults,
    required this.onArtistTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isSearching) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (searchResults.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          final artist = searchResults[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Card(
              color: Colors.white.withOpacity(0.9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      artist.imageUrl != null
                          ? NetworkImage(artist.imageUrl!)
                          : null,
                  backgroundColor: const Color(0xFF5BA4B0),
                  child:
                      artist.imageUrl == null
                          ? const Icon(Icons.person, color: Colors.white)
                          : null,
                ),
                title: Text(
                  artist.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                subtitle:
                    artist.genre != null
                        ? Text(
                          artist.genre!,
                          style: TextStyle(color: Colors.grey[600]),
                        )
                        : null,
                trailing: const Icon(
                  Icons.add_circle,
                  color: Color(0xFF5BA4B0),
                ),
                onTap: () => onArtistTap(artist),
              ),
            ),
          );
        },
      );
    }

    return const SizedBox.shrink();
  }
}
