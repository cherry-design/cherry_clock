// Copyright 2020 Mike Melnikov. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/services.dart';
import 'package:flutter_clock_helper/customizer.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';

import 'cherry_clock.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Add support for horizontal orientation only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) {
    // This creates a clock, with the ability to customize it
    runApp(ClockCustomizer((ClockModel model) => CherryClock(model)));
  });
}
