import 'package:get_it/get_it.dart';
import 'package:moodsic/core/services/api_service.dart';
import 'package:moodsic/core/services/firestore/firestore_service.dart';
import 'package:moodsic/domains/usecases/search_artists.dart';
import 'package:moodsic/domains/usecases/search_track.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Đảm bảo Firebase được khởi tạo
  await Firebase.initializeApp();

  // Đăng ký FirestoreService với dependency injection
  getIt.registerLazySingleton<FirestoreService>(
    () => FirestoreService(FirebaseFirestore.instance, FirebaseAuth.instance),
  );

  getIt.registerLazySingleton<ApiService>(() => ApiService());

  // Đăng ký các use case
  getIt.registerSingleton<SearchArtists>(SearchArtists());
  getIt.registerSingleton<SearchTracks>(SearchTracks());
}
