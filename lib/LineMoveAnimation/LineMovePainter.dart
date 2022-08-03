import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';

class LineMovePainter extends CustomPainter {
  double progress;
  List<Offset> offsets;

  LineMovePainter(this.progress, this.offsets);

  Path _createAnyPath(Size size) {
    return Path()
      // ..moveTo(size.height / 4, size.height / 4)
      // ..lineTo(size.height, size.width / 2)
      // ..lineTo(size.height / 2, size.width)
      ..quadraticBezierTo(size.height / 2, 100, size.width, size.height);
  }

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.purpleAccent
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double radiusValue = 20;
    Radius radius =  Radius.circular(radiusValue);

    Path rowPath = Path();
    rowPath.lineTo(0, size.height - radiusValue);
    rowPath.arcToPoint(
      Offset(radiusValue, size.height),
      radius: radius,
      clockwise: false,
    );
    rowPath.lineTo(size.width - radiusValue, size.height);
    rowPath.arcToPoint(
      Offset(size.width, size.height-radiusValue),
      radius: radius,
      clockwise: false,
    );
    rowPath.lineTo(size.width, 0);
    rowPath.close();

    // final path = _createAnyPath(size);
    final path = createAnimatedPath(rowPath, progress);

    canvas.drawPath(path, paint);
  }

  Path createAnimatedPath(
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

    return extractPathUntilLength(originalPath, currentLength);
  }

  Path extractPathUntilLength(
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

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
