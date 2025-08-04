import 'package:flutter/material.dart';
import 'package:moodsic/shared/widgets/track_card.dart';
import 'package:moodsic/shared/widgets/track_viewmodel.dart';

class SearchTrackResultsWidget extends StatelessWidget {
  final bool isSearching;
  final List<TrackViewmodel> searchResults;
  final Function(TrackViewmodel) onTrackTap;

  const SearchTrackResultsWidget({
    super.key,
    required this.isSearching,
    required this.searchResults,
    required this.onTrackTap,
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
      return Container(
        constraints: const BoxConstraints(maxHeight: 200),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: searchResults.length,
          itemBuilder: (context, index) {
            final track = searchResults[index];
            return TrackCard(
              id: track.id,
              title: track.name,
              url: track.imageUrl,
              artists: track.artist ?? '',
              isSelected: false, // Kết quả tìm kiếm chưa được chọn
              onTap: () => onTrackTap(track),
            );
          },
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
