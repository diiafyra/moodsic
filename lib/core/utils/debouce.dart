import 'dart:async';

class Debounce {
  Timer? _timer;

  void run(void Function() action, Duration duration) {
    _timer?.cancel();
    _timer = Timer(duration, action);
  }

  void cancel() {
    _timer?.cancel();
  }
}
