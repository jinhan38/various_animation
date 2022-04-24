import 'dart:math';

import 'package:flutter/animation.dart';

class SineCurve extends Curve {
  final double count;

  const SineCurve({this.count = 1});

  @override
  double transformInternal(double t) {
    double value = sin(count * 2 * pi * t) * 0.5 + 0.5;
    return value;
  }
}
