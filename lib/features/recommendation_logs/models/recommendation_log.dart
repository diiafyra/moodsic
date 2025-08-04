import 'package:cloud_firestore/cloud_firestore.dart';

class RecommendationLog {
  final String? imageUrl;
  final DateTime timestamp;
  final String moodText;
  final List<String> keywords;
  final double arousal;
  final double valence;

  RecommendationLog({
    this.imageUrl,
    required this.timestamp,
    required this.moodText,
    required this.keywords,
    required this.arousal,
    required this.valence,
  });

  factory RecommendationLog.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return RecommendationLog(
      imageUrl: data['imageUrl'] as String?,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      moodText: data['moodText'] as String? ?? '',
      keywords: List<String>.from(data['keywords'] ?? []),
      arousal: (data['arousal'] as num?)?.toDouble() ?? 0.0,
      valence: (data['valence'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
