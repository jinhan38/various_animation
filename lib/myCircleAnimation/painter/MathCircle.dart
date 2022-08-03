import 'dart:math' as math;

import 'package:flutter/material.dart';

/// 삼각함수 이용 클래스
class MathCircle {
  static double cos(double radians) {
    return math.cos(radians);
  }

  static double sin(double radians) {
    return math.sin(radians);
  }

  static Offset offset(double radius, double radians) {
    return Offset(
      radius * cos(radians) + radius,
      radius * sin(radians) + radius,
    );
  }
}
