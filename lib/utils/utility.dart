import 'dart:io';

import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

makeVibration() async {
  if (Platform.isIOS) {
    HapticFeedback.mediumImpact();
  } else {
    if ((await Vibration.hasVibrator())!) {
      Vibration.vibrate(duration: 50, amplitude: 100);
    }
  }
}
