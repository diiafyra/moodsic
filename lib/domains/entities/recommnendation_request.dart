class RecommendationRequest {
  final String id;
  final String userId;
  final String mood;

  RecommendationRequest({
    required this.id,
    required this.userId,
    required this.mood,
  });
}
