library fps;

import 'dart:ui';

import 'package:flutter/widgets.dart';

/// Fps callback.
typedef FpsCallback = void Function(List<FpsInfo> fps);

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
  TimingsCallback _originalOnReportTimings;
  List<FpsCallback> _fpsCallbacks = [];

  void addFpsCallback(FpsCallback fpsCallback) {
    _fpsCallbacks.add(fpsCallback);
  }

  void start(BuildContext context) async {
    if (!_started) {
      _started = true;

      _originalOnReportTimings = window.onReportTimings;
      TimingsCallback newReportTimings = (List<FrameTiming> timings) {
        if (_fpsCallbacks.isNotEmpty) {
          List<FpsInfo> fps =
          timings.map<FpsInfo>((timing) => FpsInfo(timing)).toList();
          _fpsCallbacks.forEach((callback) {
            callback(fps);
          });
        }
      };
      window.onReportTimings = newReportTimings;
    }
  }

  void stop() {
    if (_originalOnReportTimings != null) {
      window.onReportTimings = _originalOnReportTimings;
      _originalOnReportTimings = null;
    }
    _started = false;
  }
}

class FpsInfo {
  final FrameTiming frameTiming;

  FpsInfo(this.frameTiming);

  int get fps => 1000 ~/ totalSpan;

  /// The duration in milliseconds to build the frame on the UI thread.
  double get uiSpan => _formatMS(frameTiming.buildDuration);

  /// The duration in milliseconds to rasterize the frame on the GPU thread.
  double get gpuSpan => _formatMS(frameTiming.rasterDuration);

  /// The duration in milliseconds during a lifetime of a frame.
  double get totalSpan => _formatMS(frameTiming.totalSpan);

  double _formatMS(Duration duration) => duration.inMicroseconds * 0.001;

  @override
  String toString() {
    return '$runtimeType(fps: $fps, uiSpan: $uiSpan, gpuSpan: $gpuSpan, totalSpan: $totalSpan)';
  }
}
