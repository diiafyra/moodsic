import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moodsic/core/widgets/search_bar.dart';
import 'package:moodsic/domains/usecases/search_artists.dart';
import 'package:moodsic/features/survey/viewmodels/artist_selection_viewmodel.dart';
import 'package:moodsic/features/survey/viewmodels/artist_viewmodel.dart';
import 'package:moodsic/features/survey/widgets/artist_selection/empty_state_widget.dart';
import 'package:moodsic/features/survey/widgets/artist_selection/search_counter_widget.dart';
import 'package:moodsic/features/survey/widgets/artist_selection/search_results_widget.dart';
import 'package:moodsic/features/survey/widgets/artist_selection/selected_artist_widget.dart';
import 'package:provider/provider.dart';
import 'package:moodsic/shared/states/survey_provider.dart';

final getIt = GetIt.instance;

class ArtistSelectionWidget extends StatefulWidget {
  final int maxSelection;

  const ArtistSelectionWidget({super.key, this.maxSelection = 10});

  @override
  State<ArtistSelectionWidget> createState() => _ArtistSelectionWidgetState();
}

class _ArtistSelectionWidgetState extends State<ArtistSelectionWidget> {
  late final ArtistSelectionViewModel viewModel;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final surveyProvider = context.read<SurveyProvider>();

    viewModel = ArtistSelectionViewModel(
      maxSelection: widget.maxSelection,
      onSelectionChanged: (artists) {
        surveyProvider.setArtists(artists); // <- Ghi vào Provider
      },
      searchArtists: getIt<SearchArtists>(),
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
              const Text(
                'NGHỆ SĨ YÊU THÍCH CỦA BẠN?\nchọn tối đa 10',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 20),

              CSearchBar(
                hintText: 'Tìm artist',
                controller: _searchController,
                onChanged: (value) => viewModel.onSearchChanged(value, context),
              ),
              const SizedBox(height: 16),

              SelectionCounterWidget(
                selectedCount: viewModel.selectedArtists.length,
                maxSelection: widget.maxSelection,
              ),
              const SizedBox(height: 20),

              SelectedArtistsWidget(
                selectedArtists: viewModel.selectedArtists,
                onArtistRemove: viewModel.removeArtist,
              ),
              const SizedBox(height: 20),

              if (viewModel.isSearching || viewModel.searchResults.isNotEmpty)
                SearchResultsWidget(
                  isSearching: viewModel.isSearching,
                  searchResults: viewModel.searchResults,
                  onArtistTap: viewModel.addArtist,
                )
              else
                const EmptyStateWidget(),
            ],
          ),
        );
      },
    );
  }
}
