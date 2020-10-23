import 'package:flutter/foundation.dart';

class TimeInterval {
  TimeInterval({
    @required this.maxIntervalMilliSec,
  });
  final int maxIntervalMilliSec;

  DateTime startTime;
  int endTime;
  bool isStart = false;

  int get millisecond {
    if (startTime == null) {
      return 0;
    }
    return DateTime.now().millisecondsSinceEpoch -
        startTime.millisecondsSinceEpoch;
  }

  bool get isCheck {
    if (endTime == null) {
      return false;
    }
    final nowTimestamp = DateTime.now().millisecondsSinceEpoch;
    return nowTimestamp >= endTime;
  }

  void start() {
    if (!isStart) {
      isStart = true;
      startTime = DateTime.now();
      endTime = startTime.millisecondsSinceEpoch + maxIntervalMilliSec;
    }
  }

  void reset() {
    isStart = false;
  }
}
