import 'package:flutter/cupertino.dart';
import 'package:various_animation/fourthChart/FourthChart.dart';

class FourthPainter extends CustomPainter {
  // final Offset currentPoint;
  final Path followPath;
  final double chartSize;
  final Paint backgroundPaint;
  final Paint pointPaint;
  final Paint borderPaint;
  final Paint followPaint;
  final List<Offset> pointList;

  FourthPainter({
    // required this.currentPoint,
    required this.followPath,
    required this.chartSize,
    required this.backgroundPaint,
    required this.pointPaint,
    required this.borderPaint,
    required this.followPaint,
    required this.pointList,
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

    canvas.drawPath(followPath, followPaint);

    for (var offset in pointList) {
      canvas.drawCircle(offset, 8, pointPaint);
    }

    // canvas
    //
    // /// 라인
    //   ..drawPath(followPath, followPaint)
    //
    // /// 끝 점
    //   ..drawCircle(Offset(currentPoint.dx, -currentPoint.dy), 8, pointPaint);
  }

  /// 배경색
  void _drawBackground(Canvas canvas, Size size, Paint paint) {
    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, size.height), paint);
  }

  /// 차트 기준축 세우기
  void _drawBorder(
      Canvas canvas, Size size, double chartSize, Paint borderPaint) {
    /// y 축
    /// offset 1 : 시작점, offset2 : 도착점, paint 선의 형태
    canvas.drawLine(const Offset(0, 0), Offset(0, chartSize), borderPaint);

    /// x 축
    canvas.drawLine(
        Offset(0, chartSize), Offset(chartSize, chartSize), borderPaint);
  }

  /// 캔버스 위치 이동
  /// 여기서는 가운데로 이동시킬 예정이다.
  _translateCanvas(Canvas canvas, double x, double y) {
    canvas.translate(x, y);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
