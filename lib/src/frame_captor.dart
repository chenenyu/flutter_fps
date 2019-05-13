import 'dart:ui';

import 'fps.dart';
import 'fps_calculator.dart';

FrameCallback _originalOnBeginFrame;
VoidCallback _originalOnDrawFrame;

/// starts to capture frames.
void capture() {
  DateTime anchorTime;
  DateTime frameStartTime;
  DateTime frameEndTime;

  List<int> frames = []; // store cost time per frame

  _originalOnBeginFrame ??= window.onBeginFrame;
  _originalOnDrawFrame ??= window.onDrawFrame;

  FrameCallback newOnBeginFrame = (Duration timeStamp) {
    frameStartTime = DateTime.now();
    if (anchorTime == null) {
      anchorTime = frameStartTime;
    }

    _originalOnBeginFrame(timeStamp);
  };
  VoidCallback newOnDrawFrame = () {
    _originalOnDrawFrame();

    frameEndTime = DateTime.now();
    // time that last frame cost
    Duration costDuration = frameEndTime.difference(frameStartTime);
    // frame callback
    if (frameCallbacks.isNotEmpty) {
      frameCallbacks.forEach((frameCallback) => frameCallback(costDuration));
    }
    // store
    frames.add(costDuration.inMicroseconds);
    if (frameEndTime.difference(anchorTime).inMilliseconds >= 500) {
      // calc fps
      calc(frames);

      frames.clear();
      anchorTime = null;
    }
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
