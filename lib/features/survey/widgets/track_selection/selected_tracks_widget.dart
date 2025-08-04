import 'package:flutter/material.dart';
import 'package:moodsic/shared/widgets/track_card.dart';
import 'package:moodsic/shared/widgets/track_viewmodel.dart';

class SelectedTracksWidget extends StatelessWidget {
  final List<TrackViewmodel> selectedTracks;
  final Function(TrackViewmodel) onTrackRemove;

  const SelectedTracksWidget({
    super.key,
    required this.selectedTracks,
    required this.onTrackRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedTracks.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 80, // Chiều cao tương tự SelectedArtistsWidget
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: selectedTracks.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final track = selectedTracks[index];
          return SizedBox(
            width: 60, // Width cố định cho avatar
            child: TrackCard(
              id: track.id,
              title: track.name,
              url: track.imageUrl,
              artists: track.artist ?? '',
              isCompact: true, // Sử dụng dạng compact
              onTap: () => onTrackRemove(track),
            ),
          );
        },
      ),
    );
  }
}
