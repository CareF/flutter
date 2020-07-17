// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter/scheduler.dart';

/// Wraps a [ListView] that records for each frame the position of the
/// scrollable widget to [Timeline]
class WatchedScroller extends StatelessWidget {
  WatchedScroller({
    @required this.child,
    @required this.controller,
    Key key,
  })  : recorder = _ScrollRecorder(controller),
        assert(child != null),
        assert(controller != null),
        super(key: key);

  final ListView child;
  final ScrollController controller;
  final _ScrollRecorder recorder;

  @override
  Widget build(BuildContext context) {
    return Listener(
      child: child,
      onPointerDown: recorder.scrollStart,
      onPointerUp: recorder.scrollEnd,
    );
  }
}

class _ScrollRecorder {
  _ScrollRecorder(this.controller)
      : scrollerY = <double>[],
        frameTimeStamp = <int>[],
        assert(controller != null) {
    _ticker = Ticker(updateFrameInfo);
  }

  final List<double> scrollerY;
  final List<int> frameTimeStamp;
  final ScrollController controller;
  Ticker _ticker;

  void updateFrameInfo(Duration elapsed) {
    final int timeStamp = elapsed.inMicroseconds;
    final double position = controller.offset;
    frameTimeStamp.add(timeStamp);
    scrollerY.add(position);
    Timeline.instantSync('Frame_Scroll_Position', arguments: <String, dynamic>{
      'ts': timeStamp,
      'position': position,
    });
  }

  void scrollStart(PointerEvent details) {
    scrollerY.clear();
    frameTimeStamp.clear();
    _ticker.start();
  }

  void scrollEnd(PointerEvent details) {
    _ticker.stop();
    final int first = scrollerY.length ~/ 10;
    final int last = scrollerY.length - first;
    double jerk = 0;
    for(int n = first+1; n < last; n += 1) {
      jerk += _square(scrollerY[n-1] + scrollerY[n+1] - 2 * scrollerY[n]);
    }
    jerk /= last - first;
    Timeline.instantSync('Scroll_Jerk', arguments: <String, dynamic>{
      'jerk': jerk,
      'length': last - first,
    });
  }
}

double _square(double num) => num * num;
