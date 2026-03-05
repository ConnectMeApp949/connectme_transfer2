import "package:flutter/foundation.dart";

class Logger {
  /// define a singleton instance
  static final Logger _instance = Logger._internal();

  /// factory pattern
  factory Logger({String? level}) {
    if (level != null) _instance.level = level;
    return _instance;
  }

  Logger._internal(); /// call the private constructor

  String? level;

  Map level_num = {
    "trace": 0,
    "debug": 1,
    "info": 2,
    "warning": 3,
    "error": 4,
    "fatal": 5
  };
  t(msg) {
    if (level_num[level] < 1) {
      debugPrint('🔦️  ' + msg, wrapWidth: 1024);
    }
  }

  d(msg) {
    if (level_num[level] < 2) {
      debugPrint('🖌 ' + msg, wrapWidth: 1024);
    }
  }

  i(msg) {
    if (level_num[level] < 3) {
      debugPrint('ℹ️  ' + msg, wrapWidth: 1024);
    }
  }

  w(msg) {
    if (level_num[level] < 4) {
      debugPrint('⚠️  ' + msg, wrapWidth: 1024);
    }
  }

  e(msg) {
    if (level_num[level] < 5) {
      debugPrint('🚫  ' + msg, wrapWidth: 1024);
    }
  }

  f(msg) {
    if (level_num[level] < 6) {
      debugPrint('👾  ' + msg, wrapWidth: 1024);
    }
  }
}

Logger lg = Logger(level: "trace");
// Logger lg = Logger(level:"debug");
// Logger lg = Logger(level: "info");