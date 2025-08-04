import 'package:flutter/material.dart';
import 'package:moodsic/core/utils/debouce.dart';
import 'package:moodsic/domains/usecases/search_track.dart';
import 'package:moodsic/shared/widgets/track_viewmodel.dart';

class TrackSelectionViewModel extends ChangeNotifier {
  final SearchTracks searchTracks;
  final int maxSelection;
  final Function(List<TrackViewmodel>)? onSelectionChanged;
  final Debounce _debounce = Debounce();

  List<TrackViewmodel> selectedTracks = [];
  List<TrackViewmodel> searchResults = [];
  bool isSearching = false;

  TrackSelectionViewModel({
    required this.maxSelection,
    required this.searchTracks,
    this.onSelectionChanged,
  });

  void onSearchChanged(String value, BuildContext context) {
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
        final results = await searchTracks.execute(value);
        searchResults =
            results
                .where((track) => !selectedTracks.any((t) => t.id == track.id))
                .toList();
      } catch (e) {
        searchResults = [];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi tìm kiếm: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        isSearching = false;
        notifyListeners();
      }
    }, const Duration(milliseconds: 500));
  }

  void addTrack(TrackViewmodel track) {
    if (selectedTracks.length < maxSelection &&
        !selectedTracks.any((t) => t.id == track.id)) {
      selectedTracks.add(track);
      searchResults.removeWhere((t) => t.id == track.id);
      notifyListeners();
      onSelectionChanged?.call(selectedTracks);
    }
  }

  void removeTrack(TrackViewmodel track) {
    selectedTracks.removeWhere((t) => t.id == track.id);
    notifyListeners();
    onSelectionChanged?.call(selectedTracks);
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
