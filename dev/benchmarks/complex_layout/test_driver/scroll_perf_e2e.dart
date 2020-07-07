// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:e2e/e2e.dart';

import 'package:complex_layout/main.dart' as app;

Future<void> main() async {
  final E2EWidgetsFlutterBinding binding =
    E2EWidgetsFlutterBinding.ensureInitialized() as E2EWidgetsFlutterBinding;
  // framePolicy.fullyLive gives bout 80~90 frame count, depending on the device
  // model (tested on pixel 4 and moto g4) with tester.pump().
  // without tester.pump() it's 40~50 frames.
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
  // framPolicy.benchmark stuck at the testing start page
  // binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.benchmark;
  // framePolicy.benchmarkLive (see a rough implementation in the branch) would
  // perform equivalently as fullyLive but without pump.
  // binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.benchmarkLive;
  testWidgets('Test simple scrolling', (WidgetTester tester) async {
    app.main();
    // await tester.pumpWidget(app.ComplexLayoutApp());
    await tester.pumpAndSettle();
    int frameCount = 0;
    final Ticker counter = tester.createTicker((_) {frameCount ++;});
    counter.start();
    // The following is to implement
    // ```
    // await tester.drag(find.byKey(const ValueKey<String>('complex-scroll')),
    //   const Offset(0.0, -700));
    // ```
    // with some time duration.
    final Offset startLocation = tester.getCenter(find.byKey(
      const ValueKey<String>('complex-scroll')));
    final TestGesture gesture = await tester.startGesture(startLocation);
    const int gestureCount = 50;
    const double movePerEvent = -700.0 / gestureCount;
    for (int t=0; t<gestureCount; t++) {
      // 8ms is about 120 Hz sampling rate. Test shows that the data feed to the
      // engine from device has timestamp accuracy up to integer milliseconds.
      await Future<void>.delayed(const Duration(milliseconds: 8));
      await gesture.moveBy(const Offset(0.0, movePerEvent));
      // The tester.pump() mentioned above I mean here.
      await tester.pump();
    }
    await gesture.up();
    counter.dispose();
    print('Total frame during moving: $frameCount');
  });
}
