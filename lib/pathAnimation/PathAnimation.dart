
import 'dart:ui';

import 'package:flutter/material.dart';

class PathAnimation {

 static Path createAnimatedPath(
      Path originalPath,
      double animationPercent,
      ) {
    /// totalLength 선이 총 몇개로 이루어졌는지, 다시 말해 점이 몇 개 인지 계지
    // ComputeMetrics can only be iterated once!
    final totalLength = originalPath.computeMetrics().fold(0.0,
            (double prev, PathMetric metric) {
          return prev + metric.length;
        });

    final currentLength = totalLength * animationPercent;

    return _extractPathUntilLength(originalPath, currentLength);
  }

 static Path _extractPathUntilLength(
      Path originalPath,
      double length,
      ) {
    var currentLength = 0.0;

    final path = new Path();

    var metricsIterator = originalPath.computeMetrics().iterator;

    while (metricsIterator.moveNext()) {
      var metric = metricsIterator.current;
      var nextLength = currentLength + metric.length;

      final isLastSegment = nextLength > length;
      if (isLastSegment) {
        final remainingLength = length - currentLength;
        final pathSegment = metric.extractPath(0.0, remainingLength);
        path.addPath(pathSegment, Offset.zero);
        break;
      } else {
        // There might be a more efficient way of extracting an entire path
        final pathSegment = metric.extractPath(0.0, metric.length);
        path.addPath(pathSegment, Offset.zero);
      }

      currentLength = nextLength;
    }

    return path;
  }

}
