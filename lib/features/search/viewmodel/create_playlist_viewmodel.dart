// presentation/viewmodels/create_playlist_viewmodel.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CreatePlaylistViewModel extends ChangeNotifier {
  final List<dynamic> _selectedTracks = [];
  final List<dynamic> _searchResults = [];
  bool _isSearching = false;
  String _currentQuery = '';

  List<dynamic> get selectedTracks => List.unmodifiable(_selectedTracks);
  List<dynamic> get searchResults => List.unmodifiable(_searchResults);
  bool get isSearching => _isSearching;

  void onSearchChanged(String query, BuildContext context) {
    if (query.trim().isEmpty) {
      _searchResults.clear();
      _currentQuery = '';
      notifyListeners();
      return;
    }

    if (query == _currentQuery) return;

    _currentQuery = query;
    _performSearch(query);
  }

  Future<void> _performSearch(String query) async {
    _isSearching = true;
    notifyListeners();

    try {
      // Simulate API call - replace with actual search service
      await Future.delayed(const Duration(milliseconds: 800));

      // Mock search results - replace with actual implementation
      _searchResults.clear();
      _searchResults.addAll([
        MockTrack(id: '1', title: 'Song 1', artist: 'Artist 1'),
        MockTrack(id: '2', title: 'Song 2', artist: 'Artist 2'),
        MockTrack(id: '3', title: 'Song 3', artist: 'Artist 3'),
      ]);
    } catch (e) {
      _searchResults.clear();
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  void addTrack(dynamic track) {
    if (!_selectedTracks.any((t) => t.id == track.id)) {
      _selectedTracks.add(track);
      notifyListeners();
    }
  }

  void removeTrack(dynamic track) {
    _selectedTracks.removeWhere((t) => t.id == track.id);
    notifyListeners();
  }

  void clearAllTracks() {
    _selectedTracks.clear();
    notifyListeners();
  }

  Future<void> createPlaylist(String name) async {
    // Implement playlist creation service call
    print('Creating playlist: $name with ${_selectedTracks.length} tracks');

    // Reset state after creation
    _selectedTracks.clear();
    _searchResults.clear();
    _currentQuery = '';
    notifyListeners();
  }

  @override
  void dispose() {
    _selectedTracks.clear();
    _searchResults.clear();
    super.dispose();
  }
}

class MockTrack {
  final String id;
  final String title;
  final String artist;

  MockTrack({required this.id, required this.title, required this.artist});
}
