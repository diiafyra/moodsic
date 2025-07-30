class Seed {
  final int afterFilteringSize;
  final int afterRelinkingSize;
  final String href;
  final String id;
  final int initialPoolSize;
  final String type;

  Seed({
    required this.afterFilteringSize,
    required this.afterRelinkingSize,
    required this.href,
    required this.id,
    required this.initialPoolSize,
    required this.type,
  });

  factory Seed.fromJson(Map<String, dynamic> json) {
    return Seed(
      afterFilteringSize: json['afterFilteringSize'] ?? 0,
      afterRelinkingSize: json['afterRelinkingSize'] ?? 0,
      href: json['href'] ?? '',
      id: json['id'] ?? '',
      initialPoolSize: json['initialPoolSize'] ?? 0,
      type: json['type'] ?? '',
    );
  }
}
