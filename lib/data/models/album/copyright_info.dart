class CopyrightInfo {
  final String text;
  final String type;

  CopyrightInfo({ required this.text, required this.type});

  factory CopyrightInfo.fromJson(Map<String, dynamic> json) {
    return CopyrightInfo(
      text: json['text'],
      type: json['type'],
    );
  }
}