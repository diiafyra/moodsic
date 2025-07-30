class ImageModel {
  final String url;
  final int height;
  final int width;

  ImageModel({required this.url, required this.height, required this.width});

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      url: json['url'],
      height: json['height'] ?? 0,
      width: json['width'] ?? 0,
    );
  }
}
