import 'package:flutter/material.dart';

import 'fps.dart';

OverlayEntry _indicatorEntry;

void insertIndicator(BuildContext context, {Widget indicator}) {
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    OverlayState overlayState = Overlay.of(context);
    _indicatorEntry = OverlayEntry(builder: (context) {
      return indicator ?? Indicator();
    });
    overlayState.insert(_indicatorEntry);
  });
}

void removeIndicator() {
  if (_indicatorEntry != null) {
    _indicatorEntry.remove();
    _indicatorEntry = null;
  }
}

/// Default indicator.
class Indicator extends StatefulWidget {
  @override
  _IndicatorState createState() {
    return _IndicatorState();
  }
}

class _IndicatorState extends State<Indicator> {
  double _fps = 0;

  bool _visible = true;
  double _left = 15.0;
  double _top = 115.0;

  @override
  void initState() {
    super.initState();
    Fps.instance.addFpsCallback((fps) {
      setState(() {
        this._fps = fps;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget widget = Material(
      child: Container(
        padding: EdgeInsets.all(2),
        color: Colors.grey.withOpacity(0.3),
        child: Text(
          'fps:${_fps.toStringAsFixed(0)}',
          style: TextStyle(fontSize: 12, color: Colors.lightBlue),
        ),
      ),
    );
    return Stack(
      children: <Widget>[
        Positioned(
          left: _left,
          top: _top,
          child: Draggable(
            child: Visibility(
              visible: _visible,
              child: widget,
            ),
            feedback: widget,
            onDragStarted: () {
              setState(() {
                _visible = false;
              });
            },
            onDragEnd: (DraggableDetails details) {
              if (mounted) {
                setState(() {
                  _visible = true;
                  _left = details.offset.dx;
                  _top = details.offset.dy;
                });
              }
            },
          ),
        ),
      ],
    );
  }
}
