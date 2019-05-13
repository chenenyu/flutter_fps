# flutter-fps

A Flutter library to catch fps.

## Getting Started

In your flutter project add the dependency:

```yaml
dependencies:
  ...
  flutter_fps: ^0.0.1
```

## Usage:

Import first:  

`import 'package:flutter_fps/flutter_fps.dart';`

Then in your top level `StatefulWidget`, add the following line:  

```dart
@override
void initState() {
  super.initState();
  Fps.instance.start(context);
}
```
