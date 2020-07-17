// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// This file is not used for benchmark but is a helper file to develop benchmark

import 'dart:async';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart' hide TypeMatcher, isInstanceOf;

void main() {
  group('Waiting for physical input', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();

      await driver.waitUntilFirstFrameRasterized();
    });

    tearDownAll(() async {
      if (driver != null)
        driver.close();
    });

    test('waiting...', () async {
      // The slight initial delay avoids starting the timing during a
      // period of increased load on the device. Without this delay, the
      // benchmark has greater noise.
      // See: https://github.com/flutter/flutter/issues/19434
      await Future<void>.delayed(const Duration(milliseconds: 250));
       await driver.tap(find.byTooltip('Open navigation menu'));
       await driver.tap(find.byValueKey('record-switcher'));

      await driver.forceGC();

      final Timeline timeline = await driver.traceAction(() async {
        // Find the scrollable stock list
        await Future<void>.delayed(const Duration(seconds: 10));
      });

      final TimelineSummary summary = TimelineSummary.summarize(timeline);
      const String summaryName = 'waiting';
      await summary.writeSummaryToFile(summaryName, pretty: true);
      await summary.writeTimelineToFile(summaryName, pretty: true);
    });
  });
}
