import 'dart:ui';

import 'package:flutter/material.dart';

class CustomTween extends Tween<double> {
  CustomTween({
    required double begin,
    required double end,
  }) : super(begin: begin, end: end);

  @override
  double lerp(double t) {
    final middle = (end! - begin!) / 2;
    if (t < 0.2) {
      return super.lerp(begin!);
    } else if (t < 0.4) {
      return super.lerp(middle);
    } else if (t < 0.6) {
      return super.lerp(end!);
    } else if (t < 0.8) {
      return super.lerp(middle);
    }
    return super.lerp(end!);
  }
}
