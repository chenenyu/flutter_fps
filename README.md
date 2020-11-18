# flutter_fps

[![pub package](https://img.shields.io/pub/v/flutter_fps.svg)](https://pub.dev/packages/flutter_fps)

A Flutter library to catch fps.

## Getting Started

In your flutter project add the dependency:

```yaml
dependencies:
  ...
  flutter_fps: ^0.1.0
```

## Usage:

```dart
import 'package:flutter_fps/flutter_fps.dart';

Fps.instance.start();
Fps.instance.addFpsCallback((fpsInfo) {
  print(fpsInfo);
});
```
