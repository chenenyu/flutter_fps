import 'fps.dart';

const int _oneFrameTime = 1 * 1000 * 1000 ~/ 60; // in microseconds

/// Calculates fps according to the frame list.
void calc(List<int> frames) async {
  assert(frames != null);

  int droppedCount = 0;
  frames.forEach((int time) {
    if (time > _oneFrameTime) {
      droppedCount += time ~/ _oneFrameTime;
    }
  });
  double fps = 60 * frames.length / (frames.length + droppedCount);
//  print('frame list: ${frames.toString()}');
//  print('total frames: ${frames.length} dropped count: $droppedCount');
//  print('fps: $fps');
  if (fpsCallbacks.isNotEmpty) {
    fpsCallbacks.forEach((fpsCallback) => fpsCallback(fps));
  }
}
