import 'package:moodsic/core/services/firestore_service.dart';

class RecommendationRepository {
  final FirestoreService _firestoreService;

  RecommendationRepository(this._firestoreService);

  Future<int> getTotalRequests() async {
    return await _firestoreService.getTotalRequests();
  }
}
