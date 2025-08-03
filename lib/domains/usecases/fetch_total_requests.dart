import 'package:moodsic/data/repositories/recommendation_repository.dart';

class FetchTotalRequests {
  final RecommendationRepository _recommendationRepository;

  FetchTotalRequests(this._recommendationRepository);

  Future<int> execute() async {
    return await _recommendationRepository.getTotalRequests();
  }
}
