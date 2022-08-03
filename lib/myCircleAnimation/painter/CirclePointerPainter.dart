import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:various_animation/myCircleAnimation/painter/MathCircle.dart';

class CirclePointerPainter extends CustomPainter {
  final double radius;
  final double radians;

  CirclePointerPainter(
      this.radius, this.radians);

  @override
  void paint(Canvas canvas, Size size) {
    var pointPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    var innerCirclePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final textSpan = TextSpan(
      text: "(${(radius * math.cos(radians)).round()}, "
          "${(radius * math.sin(radians)).round()})",
      style: const TextStyle(color: Colors.black, fontSize: 16),
    );

    final textPainter =
        TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    textPainter.layout(
      minWidth: 0,
      maxWidth: 200,
    );

    /// 포인터 그리기
    /// 중심점 세팅
    /// 고정값
    Offset center = Offset(size.width / 2, size.height / 2);

    /// 삼각함수 이용하여 회전하는 pointer의 위치 구하기
    Offset pointOnCircle =MathCircle.offset(radius , radians);

    canvas.drawCircle(pointOnCircle, 10, pointPaint);

    if (math.cos(radians) < 0.0) {
      /// 포인터가 원의 좌측면에 있을 때
      /// 포인터가 반바뀌 도는 동안에 원이 커졌다가 작아진다.
      canvas.drawCircle(center, -radius * math.cos(radians), innerCirclePaint);

      /// 포인터의 좌하단에 좌표 나타낸다.
      textPainter.paint(
        canvas,
        pointOnCircle + Offset(-70, 10),
      );
    } else {
      /// 포인터가 원의 우측면에 있을 때
      /// 포인터가 반바뀌 도는 동안에 원이 커졌다가 작아진다.
      canvas.drawCircle(center, radius * math.cos(radians), innerCirclePaint);

      /// 포인터의 우하단 좌표 나타낸다.
      textPainter.paint(
        canvas,
        pointOnCircle + Offset(10, 10),
      );
    }

    /// 직사각형 그리기
    var path = Path();

    /// 시작점으로 이동
    path.moveTo(center.dx, center.dy);

    /// 중심점에서 포인터로 선 그리기
    path.lineTo(pointOnCircle.dx, pointOnCircle.dy);

    /// 포인터의 x값을 따라가되, y값은 항상 중심
    path.lineTo(pointOnCircle.dx, center.dy);

    /// close를 호출하면 끝나는 지점부터 시작점까지를 연결한다.
    path.close();

    var trianglePaint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, trianglePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
