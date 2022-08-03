import 'package:flutter/material.dart';
import 'package:various_animation/curves/sine_curve.dart';
import 'package:various_animation/fourthChart/FourthPainter.dart';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:various_animation/pathAnimation/PathAnimation.dart';

class Data {
  double x;
  double y;

  Data(this.x, this.y);
}

class FourthChart extends StatefulWidget {
  const FourthChart({Key? key}) : super(key: key);

  @override
  _FourthChartState createState() => _FourthChartState();
}

class _FourthChartState extends State<FourthChart>
    with SingleTickerProviderStateMixin {
  final List<Data> dataList = [];
  late AnimationController _animationController;

  double chartWidth = 400;
  double chartHeight = 400;
  double xSpacing = 0;
  double ySpacing = 0;
  Paint followPaint = Paint();
  Paint borderPaint = Paint();
  var followPath = Path();
  double xMax = 0;
  double yMax = 0;
  double xSum = 0;
  double ySum = 0;
  final List<Offset> pointList = [];

  static final linearTween = Tween<double>(begin: 0, end: 1)
      .chain(CurveTween(curve: Curves.decelerate));

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  initData() {
    followPath.reset();
    dataList.clear();
    pointList.clear();
    dataList.add(Data(1, 1));
    dataList.add(Data(2, 3));
    dataList.add(Data(3, 9));
    dataList.add(Data(4, 6));
    dataList.add(Data(5, 4));
    dataList.add(Data(6, 3));
    dataList.add(Data(7, 8));

    followPaint.color = Colors.blue;
    followPaint.style = PaintingStyle.stroke;
    followPaint.strokeWidth = 4;
    borderPaint.color = Colors.black;
    borderPaint.style = PaintingStyle.fill;
    borderPaint.strokeWidth = 2;

    xMax = dataList.map<double>((e) => e.x).toList().reduce(max);
    yMax = dataList.map<double>((e) => e.y).toList().reduce(max);

    xSpacing = chartWidth / xMax;
    ySpacing = chartHeight / yMax;


    for (var data in dataList) {
      followPath.lineTo(data.x * xSpacing, (data.y * ySpacing) * -1);
      pointList.add(Offset(data.x * xSpacing, (data.y * ySpacing) * -1));
    }
  }

  @override
  Widget build(BuildContext context) {
    initData();

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
                animation: _animationController,
                builder: (_, __) {
                  return SizedBox(
                    width: 400,
                    height: 400,
                    child: CustomPaint(
                      painter: FourthPainter(
                        followPath: PathAnimation.createAnimatedPath(
                            followPath, _animationController.value),
                        chartSize: 400,
                        backgroundPaint: Paint()..color = Colors.grey.shade200,
                        pointPaint: Paint()..color = Colors.red,
                        borderPaint: borderPaint,
                        followPaint: followPaint,
                        pointList: pointList,
                      ),
                    ),
                  );
                }),
            ElevatedButton(
                onPressed: () {
                  _animationController.reset();
                  _animationController.forward();
                },
                child: const Text("start"))
          ],
        ),
      ),
    );
  }
}
