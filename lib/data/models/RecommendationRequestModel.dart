class RecommendationRequestModel {
  final String id;
  final String userId;
  final String mood;

  RecommendationRequestModel({
    required this.id,
    required this.userId,
    required this.mood,
  });

  factory RecommendationRequestModel.fromMap(
    Map<String, dynamic> data,
    String id,
  ) {
    return RecommendationRequestModel(
      id: id,
      userId: data['userId'] ?? '',
      mood: data['mood'] ?? '',
    );
  }
}
