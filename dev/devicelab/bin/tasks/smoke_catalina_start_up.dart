// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_devicelab/tasks/perf_tests.dart';
import 'package:flutter_devicelab/framework/framework.dart';

Future<void> main(List<String> args) async {
  // It's intended to use the Gallery startup test as a smoke test on macOS
  // Catalina.
  // Using default Operating System: android. Not sure why the above comments 
  // says about macOS. 
  // deviceOperatingSystem = DeviceOperatingSystem.android;
  await setupContext(args);
  await task(createFlutterGalleryStartupTest());
}
