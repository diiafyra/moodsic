Function(String id) buildLikeHandler({
  required bool isLiked,
  required void Function(bool newState) onToggle,
}) {
  return (String id) {
    final newState = !isLiked;
    onToggle(newState);
    Future.delayed(const Duration(milliseconds: 300), () {
      if (newState) {
        print("🎧 API: Thêm playlist $id vào yêu thích");
      } else {
        print("🗑️ API: Gỡ playlist $id khỏi yêu thích");
      }
    });
  };
}
