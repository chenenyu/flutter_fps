import 'dart:async';
import 'dart:ui';

import 'fps.dart';
import 'fps_calculator.dart';

FrameCallback _originalOnBeginFrame;
VoidCallback _originalOnDrawFrame;

/// The interval of calc fps.
const int _calcInterval = 200;

/// starts to capture frames.
void capture() {
  Timer timer;
  bool skipFrame = false;
  DateTime anchorTime;
  DateTime frameStartTime;
  DateTime frameEndTime;

  List<int> frames = []; // store cost time per frame

  _originalOnBeginFrame ??= window.onBeginFrame;
  _originalOnDrawFrame ??= window.onDrawFrame;

  FrameCallback newOnBeginFrame = (Duration timeStamp) {
    if (timer != null && timer.isActive) {
      timer.cancel();
    }

    if (!skipFrame) {
      frameStartTime = DateTime.now();
      if (anchorTime == null) {
        anchorTime = frameStartTime;
      }
    }

    _originalOnBeginFrame(timeStamp);
  };
  VoidCallback newOnDrawFrame = () {
    _originalOnDrawFrame();

    if (skipFrame) {
      skipFrame = false;
      return;
    }

    frameEndTime = DateTime.now();
    // time that last frame cost
    Duration costDuration = frameEndTime.difference(frameStartTime);
    // frame callback
    if (frameCallbacks.isNotEmpty) {
      frameCallbacks.forEach((frameCallback) => frameCallback(costDuration));
    }
    // store
    frames.add(costDuration.inMicroseconds);

    if (frameEndTime
        .difference(anchorTime)
        .inMilliseconds >= _calcInterval) {
      // calc fps
      calc(frames);

      frames.clear();
      anchorTime = null;
    }

    // emit idle callback after 500ms
    timer = Timer(Duration(milliseconds: 500), () {
      fpsCallbacks.forEach((fpsCallback) => fpsCallback(0));
      // skip next frame to avoid indicator's circulation rendering
      skipFrame = true;
    });
  };

  window.onBeginFrame = newOnBeginFrame;
  window.onDrawFrame = newOnDrawFrame;
}

/// resets frame callback.
void reset() {
  if (_originalOnBeginFrame != null) {
    window.onBeginFrame = _originalOnBeginFrame;
    _originalOnBeginFrame = null;
  }
  if (_originalOnDrawFrame != null) {
    window.onDrawFrame = _originalOnDrawFrame;
    _originalOnDrawFrame = null;
  }
}
