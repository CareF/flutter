// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:flutter_devicelab/framework/framework.dart';
import 'package:flutter_devicelab/framework/utils.dart';

import 'package:flutter_devicelab/tasks/perf_tests.dart' show WebCompileTest;
import 'package:flutter_devicelab/tasks/test_context.dart';

Future<void> main(List<String> args) async {
  disableContext(args);
  await task(const NewGalleryWebCompileTest().run);
}

/// Measures the time to compile the New Flutter Gallery to JavaScript
/// and the size of the compiled code.
class NewGalleryWebCompileTest {
  const NewGalleryWebCompileTest();

  String get metricKeyPrefix => 'new_gallery';

  /// Runs the test.
  Future<TaskResult> run() async {
    await gitClone(path: 'temp', repo: 'https://github.com/flutter/gallery.git');

    final Map<String, Object> metrics = await inDirectory<Map<String, int>>(
      'temp/gallery',
      () async {
        await flutter('doctor');

        return await WebCompileTest.runSingleBuildTest(
          directory: 'temp/gallery',
          metric: metricKeyPrefix,
          measureBuildTime: true,
        );
      },
    );

    rmTree(Directory('temp'));

    return TaskResult.success(metrics, benchmarkScoreKeys: metrics.keys.toList());
  }
}
