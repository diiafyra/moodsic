import 'package:moodsic/data/repositories/RecommendationRepository.dart';

class FetchTotalRequests {
  final RecommendationRepository _recommendationRepository;

  FetchTotalRequests(this._recommendationRepository);

  Future<int> execute() async {
    return await _recommendationRepository.getTotalRequests();
  }
}
