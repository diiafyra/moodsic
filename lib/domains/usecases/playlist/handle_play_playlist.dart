Function(String id) buildPlayHandler({
  required bool isPlaying,
  required void Function(bool newState) onToggle,
}) {
  return (String id) {
    final newState = !isPlaying;
    onToggle(newState);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (newState) {
        print("▶️ API: Phát track $id");
      } else {
        print("⏸️ API: Dừng track $id");
      }
    });
  };
}
