import 'dart:ui';

import 'package:flutter/widgets.dart';

import 'frame_captor.dart';

/// Fps callback. 0 means idle.
typedef FpsCallback = void Function(double fps);

List<FpsCallback> fpsCallbacks = [];
List<FrameCallback> frameCallbacks = [];

class Fps {
  Fps._();

  static Fps _instance;

  static Fps get instance {
    if (_instance == null) {
      _instance = Fps._();
    }
    return _instance;
  }

  bool _started = false;

  void addFpsCallback(FpsCallback fpsCallback) {
    fpsCallbacks.add(fpsCallback);
  }

  void addFrameCallback(FrameCallback frameCallback) {
    frameCallbacks.add(frameCallback);
  }

  void start(BuildContext context,
/*{bool showIndicator = true, Widget indicator }*/) async {
    if (!_started) {
      _started = true;
      capture();
//      if (showIndicator) {
//        insertIndicator(context, indicator: indicator);
//      }
    }
  }

  void stop() {
    reset();
//    removeIndicator();
    _started = false;
  }
}
