Map<String, double> calculateCircumplex(Map<String, double> emotions) {
  final happy = emotions['Happy'] ?? 0;
  final sad = emotions['Sad'] ?? 0;
  final calm = emotions['Calm'] ?? 0;
  final energetic = emotions['Energetic'] ?? 0;

  final valenceNorm = (happy - sad) / (happy + sad + 1e-6); // tránh chia 0
  final arousalNorm = (energetic - calm) / (energetic + calm + 1e-6);

  return {'valence': valenceNorm, 'arousal': arousalNorm};
}
