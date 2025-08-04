import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moodsic/core/widgets/search_bar.dart';
import 'package:moodsic/domains/usecases/search_track.dart';
import 'package:moodsic/features/survey/viewmodels/track_selection_viewmodel.dart';
import 'package:moodsic/features/survey/widgets/artist_selection/empty_state_widget.dart';
import 'package:moodsic/features/survey/widgets/artist_selection/search_counter_widget.dart';
import 'package:moodsic/features/survey/widgets/track_selection/search_track_results_widget.dart';
import 'package:moodsic/features/survey/widgets/track_selection/selected_tracks_widget.dart';
import 'package:moodsic/shared/widgets/track_viewmodel.dart';

final getIt = GetIt.instance;

class TrackSelectionWidget extends StatefulWidget {
  final Function(List<TrackViewmodel>)? onSelectionChanged;
  final int maxSelection;
  final bool isCreatePlaylist;

  const TrackSelectionWidget({
    super.key,
    this.onSelectionChanged,
    this.maxSelection = 10,
    this.isCreatePlaylist = false,
  });

  @override
  State<TrackSelectionWidget> createState() => _TrackSelectionWidgetState();
}

class _TrackSelectionWidgetState extends State<TrackSelectionWidget> {
  late final TrackSelectionViewModel viewModel;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    viewModel = TrackSelectionViewModel(
      maxSelection: widget.maxSelection,
      onSelectionChanged: widget.onSelectionChanged,
      searchTracks: getIt<SearchTracks>(),
    );
    _searchController.addListener(() {
      viewModel.onSearchChanged(_searchController.text, context);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!widget.isCreatePlaylist) ...[
                const Text(
                  'BÀI HÁT YÊU THÍCH CỦA BẠN?\nchọn tối đa 10',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 20),
              ],
              CSearchBar(
                hintText: 'Tìm bài hát',
                controller: _searchController,
                onChanged: (value) => viewModel.onSearchChanged(value, context),
              ),
              const SizedBox(height: 16),

              if (!widget.isCreatePlaylist) ...[
                SelectionCounterWidget(
                  selectedCount: viewModel.selectedTracks.length,
                  maxSelection: widget.maxSelection,
                ),
                const SizedBox(height: 20),

                SelectedTracksWidget(
                  selectedTracks: viewModel.selectedTracks,
                  onTrackRemove: viewModel.removeTrack,
                ),
                const SizedBox(height: 20),
              ],
              if (viewModel.isSearching || viewModel.searchResults.isNotEmpty)
                SearchTrackResultsWidget(
                  isSearching: viewModel.isSearching,
                  searchResults: viewModel.searchResults,
                  onTrackTap: viewModel.addTrack,
                )
              else if (viewModel.selectedTracks.isEmpty)
                const EmptyStateWidget(),
            ],
          ),
        );
      },
    );
  }
}
