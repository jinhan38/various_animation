import 'package:flutter/material.dart';

class JPainter extends CustomPainter {
  final Offset currentPoint;
  final Path followPath;
  final double chartSize;
  final Paint backgroundPaint;
  final Paint pointPaint;
  final Paint borderPaint;
  final Paint followPaint;

  JPainter({
    required this.currentPoint,
    required this.followPath,
    required this.chartSize,
    required this.backgroundPaint,
    required this.pointPaint,
    required this.borderPaint,
    required this.followPaint,
  });


  @override
  void paint(Canvas canvas, Size size) {
    _drawBackground(canvas, size, backgroundPaint);
    _translateCanvas(canvas, size.width / 2 - chartSize / 2, size.height / 2 - chartSize / 2);
    _drawBorder(canvas, size, chartSize, borderPaint);
    _translateCanvas(canvas, 0, chartSize);
    canvas
      ..drawPath(followPath, followPaint)
      ..drawCircle(Offset(currentPoint.dx, -currentPoint.dy), 4, pointPaint);
  }

  /// 현재 painter의 배경
  void _drawBackground(Canvas canvas, Size size, Paint paint) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  /// 차트 가로, 세로 기준 축 그리기
  void _drawBorder(Canvas canvas, Size size, double chartSize, Paint paint) {
    canvas
      ..drawLine(const Offset(0, 0), Offset(0, chartSize), paint)
      ..drawLine(Offset(0, chartSize), Offset(chartSize, chartSize), paint);
  }

  /// 캔버스 위치 이동
  _translateCanvas(Canvas canvas, double x, double y) {
    canvas.translate(x, y);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
