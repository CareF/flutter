// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_devicelab/tasks/gallery.dart';
import 'package:flutter_devicelab/framework/adb.dart';
import 'package:flutter_devicelab/framework/framework.dart';
import 'package:flutter_devicelab/tasks/test_context.dart';

Future<void> main(List<String> args) async {
  deviceOperatingSystem = DeviceOperatingSystem.android;
  await setupContext(args);
  await task(() async {
    final TaskResult withoutSemantics = await createGalleryTransitionTest()();
    final TaskResult withSemantics = await createGalleryTransitionTest(semanticsEnabled: true)();

    final List<String> benchmarkScoreKeys = <String>[];
    final Map<String, dynamic> data = <String, dynamic>{};
    for (final String key in withSemantics.benchmarkScoreKeys) {
      final String deltaKey = 'delta_$key';
      data[deltaKey] = withSemantics.data[key] - withoutSemantics.data[key];
      data['semantics_$key'] = withSemantics.data[key];
      data[key] = withoutSemantics.data[key];
      benchmarkScoreKeys.add(deltaKey);
    }

    return TaskResult.success(data, benchmarkScoreKeys: benchmarkScoreKeys);
  });
}
