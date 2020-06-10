// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_devicelab/framework/framework.dart';
import 'package:flutter_devicelab/tasks/build_benchmarks.dart';
import 'package:flutter_devicelab/tasks/test_context.dart';

Future<void> main(List<String> args) async {
  disableContext(args);
  await task(createAndroidBuildBenchmarkTask());
}
