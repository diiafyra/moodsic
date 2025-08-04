import 'package:flutter/material.dart';
import 'package:moodsic/core/utils/debouce.dart';
import 'package:moodsic/domains/usecases/search_artists.dart';
import 'package:moodsic/features/survey/viewmodels/artist_viewmodel.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class ArtistSelectionViewModel extends ChangeNotifier {
  final SearchArtists searchArtists;
  final int maxSelection;
  final Function(List<ArtistViewmodel>)? onSelectionChanged;
  final Debounce _debounce = Debounce();

  List<ArtistViewmodel> selectedArtists = [];
  List<ArtistViewmodel> searchResults = [];
  bool isSearching = false;

  ArtistSelectionViewModel({
    required this.maxSelection,
    required this.searchArtists,
    this.onSelectionChanged,
  });

  void onSearchChanged(String value, BuildContext context) {
    debugPrint('SEARCH ${value}');
    if (value.trim().isEmpty) {
      searchResults = [];
      isSearching = false;
      notifyListeners();
      return;
    }

    _debounce.run(() async {
      isSearching = true;
      notifyListeners();
      try {
        final results = await searchArtists.execute(value);
        searchResults =
            results
                .where(
                  (artist) =>
                      !selectedArtists.any(
                        (selected) => selected.id == artist.id,
                      ),
                )
                .toList();
        isSearching = false;
        notifyListeners();
      } catch (e) {
        isSearching = false;
        searchResults = [];
        notifyListeners();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi tìm kiếm: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }, const Duration(milliseconds: 500));
  }

  void addArtist(ArtistViewmodel artist) {
    if (selectedArtists.length < maxSelection &&
        !selectedArtists.any((selected) => selected.id == artist.id)) {
      selectedArtists.add(artist);
      searchResults.remove(artist);
      notifyListeners();
      onSelectionChanged?.call(selectedArtists);
    }
  }

  void removeArtist(ArtistViewmodel artist) {
    selectedArtists.remove(artist);
    notifyListeners();
    onSelectionChanged?.call(selectedArtists);
  }

  void clearSearch() {
    searchResults.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce.cancel();
    super.dispose();
  }
}
