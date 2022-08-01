import 'package:flutter/material.dart';
import 'package:various_animation/newChart/NewPainter/NewPainter.dart';

class NewChartScreen extends StatefulWidget {
  final Animatable<double> mainCurve;
  final Duration duration;
  final double size;

  NewChartScreen({
    required this.mainCurve,
    this.size = 200,
    this.duration = const Duration(seconds: 1),
    Key? key,
  }) : super(key: key);

  @override
  _NewChartScreenState createState() => _NewChartScreenState();
}

class _NewChartScreenState extends State<NewChartScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  Animatable<double> get _mainCurve => widget.mainCurve;

  Duration get _duration => widget.duration;

  double get _size => widget.size;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: _duration);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var intervalValue = 0.0;
    var followPath = Path();
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (_, child) {
                    if (intervalValue >= _animationController.value) {
                      followPath.reset();
                    }
                    intervalValue = _animationController.value;

                    /// Curvs의 Tween 배열 값을 적용해서 계산한 값을 리턴한다.
                    final val = _mainCurve.evaluate(_animationController);
                    print(val);
                    followPath.lineTo(
                        _animationController.value * _size, -val * _size);
                    Paint followPaint = Paint();
                    followPaint.color = Colors.blue;
                    followPaint.style = PaintingStyle.stroke;
                    followPaint.strokeWidth = 4;
                    Paint borderPaint = Paint();
                    borderPaint.color = Colors.black;
                    borderPaint.style = PaintingStyle.fill;
                    borderPaint.strokeWidth = 2;

                    /// Offset에서 x 축은 animationController 따라 그대로 이동하고
                    /// y 축은 그냥 controller 값 받아서 처리, y 축은 tween보간한 처리
                    return CustomPaint(
                      painter: NewPainter(
                          currentPoint: Offset(
                              _size * _animationController.value,
                              val * _size),
                          followPath: followPath,
                          chartSize: _size,
                          backgroundPaint: Paint()..color = Colors.grey.shade200,
                          pointPaint: Paint()..color = Colors.red,
                          borderPaint: borderPaint,
                          followPaint: followPaint),
                    );
                  }),
            ),
            ElevatedButton(
                onPressed: () {
                  _animationController.repeat();
                },
                child: const Text("Third"))
          ],
        ),
      ),
    );
  }
}
