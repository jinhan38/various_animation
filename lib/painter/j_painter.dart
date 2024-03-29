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
    /// 배경 그리기
    _drawBackground(canvas, size, backgroundPaint);

    /// 캔버스 위치 이동
    _translateCanvas(canvas, size.width / 2 - chartSize / 2,
        size.height / 2 - chartSize / 2);

    /// 캔버스 위치 이동한 시점에서 x, y축 그리기
    _drawBorder(canvas, size, chartSize, borderPaint);

    /// 캔버스 위치 이동한 시점에서 시작 점 그리기
    _translateCanvas(canvas, 0, chartSize);

    /// 현재 캔버스의 위치에서부터 그림을 그리기 시작한다.
    canvas

      /// 라인
      ..drawPath(followPath, followPaint)

      /// 끝 점
      ..drawCircle(Offset(currentPoint.dx, -currentPoint.dy), 8, pointPaint);
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
