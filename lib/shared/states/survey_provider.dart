import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moodsic/data/models/music_profle.dart';
import 'package:moodsic/shared/widgets/track_viewmodel.dart';
import 'package:moodsic/features/survey/viewmodels/artist_viewmodel.dart';
import 'package:get_it/get_it.dart';
import 'package:moodsic/core/services/firestore/firestore_service.dart';

class SurveyProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirestoreService _firestoreService = GetIt.I<FirestoreService>();

  List<String> selectedGenres = [];
  List<ArtistViewmodel> selectedArtists = [];
  List<TrackViewmodel> selectedTracks = [];

  SurveyProvider() {
    _initializeMusicProfile();
  }

  Future<void> _initializeMusicProfile() async {
    try {
      developer.log('[SurveyProvider] Initializing music profile...');
      final musicProfile = await _firestoreService.getMusicProfile();

      if (musicProfile != null) {
        selectedGenres = musicProfile.genres;
        selectedArtists = musicProfile.artists;
        selectedTracks = musicProfile.tracks;

        developer.log(
          '[SurveyProvider] Initialized with: '
          'Genres: $selectedGenres, '
          'Artists: ${selectedArtists.map((a) => a.id).toList()}, '
          'Tracks: ${selectedTracks.map((t) => t.id).toList()}',
        );
      } else {
        developer.log('[SurveyProvider] No active music profile found.');
      }

      notifyListeners();
    } catch (e, stack) {
      developer.log(
        '[SurveyProvider] Error initializing music profile: $e',
        error: e,
        stackTrace: stack,
      );
    }
  }

  void setGenres(List<String> genres) {
    selectedGenres = genres;
    developer.log('[SurveyProvider] setGenres: $genres');
    notifyListeners();
  }

  void setArtists(List<ArtistViewmodel> artists) {
    selectedArtists = artists;
    developer.log(
      '[SurveyProvider] setArtists: ${artists.map((a) => a.id).toList()}',
    );
    notifyListeners();
  }

  void setTracks(List<TrackViewmodel> tracks) {
    selectedTracks = tracks;
    developer.log(
      '[SurveyProvider] setTracks: ${tracks.map((t) => t.id).toList()}',
    );
    notifyListeners();
  }

  void reset() {
    selectedGenres.clear();
    selectedArtists.clear();
    selectedTracks.clear();
    developer.log('[SurveyProvider] State reset.');
    notifyListeners();
  }

  Future<void> saveMusicProfile() async {
    try {
      final profile = MusicProfile(
        genres: selectedGenres,
        artists: selectedArtists,
        tracks: selectedTracks,
        isActive: true,
      );

      await _firestoreService.saveMusicProfile(profile);

      developer.log('[SurveyProvider] Music profile saved successfully.');
    } catch (e, stack) {
      developer.log(
        '[SurveyProvider] Failed to save music profile: $e',
        error: e,
        stackTrace: stack,
      );
      throw Exception('Failed to save music profile: $e');
    }
  }
}
