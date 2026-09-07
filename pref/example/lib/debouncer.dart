import 'dart:async';

import 'package:flutter/foundation.dart';

/// Delays the execution of an action by [duration].
class Debouncer {
  Debouncer({required this.duration});
  final Duration duration;

  Timer? _timer;

  void run(VoidCallback action) {
    if (_timer?.isActive ?? false) {
      _timer!.cancel();
    }
    _timer = Timer(duration, action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
