class ExternalIds {
  final String isrc;
  final String ean;
  final String upc;

  ExternalIds({required this.isrc, required this.ean, required this.upc});

  factory ExternalIds.fromJson(Map<String, dynamic> json) {
    return ExternalIds(
      isrc: json['url'],
      ean: json['ean'],
      upc: json['upc'],
    );
  }
}
