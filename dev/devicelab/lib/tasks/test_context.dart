// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import '../framework/adb.dart';

/// To setup the context variables for the tests, according to the arguments 
/// provided from the caller.
/// 
/// The first argument is the default device.
/// Currently it's only used to set up the default device. 
Future<void> setupContext(List<String> args) async {
  if (args.isNotEmpty) {
    await devices.chooseWorkingDeviceById(args[0]);
  }
}

void disableContext(List<String> args) {
  if (args.isNotEmpty) {
    print('Unexpected arguements: $args.'
          'Device-id is not supported for this test.');
  }
  }
}