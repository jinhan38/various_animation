import 'package:flutter/material.dart';
import 'package:various_animation/curves/sine_curve.dart';
import 'package:various_animation/fourthChart/FourthPainter.dart';
import 'dart:math';
import 'package:collection/collection.dart';

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

  /// SEQUENCE TWEEN - combine a sequence of tweens into one
  static final tweenSequence = TweenSequence(
    <TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40.0,
      ),
      TweenSequenceItem<double>(
        tween: ConstantTween<double>(1.0),
        weight: 20.0,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1.0, end: 0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 40.0,
      ),
    ],
  );

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

  static final linearTween =
      Tween<double>(begin: 0, end: 1).chain(CurveTween(curve: SineCurve()));

  late var tSequence;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 5000));

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
    dataList.add(Data(6, 9));
    dataList.add(Data(12, 6));
    dataList.add(Data(4, 4));
    dataList.add(Data(9, 3));
    dataList.add(Data(6, 8));

    followPaint.color = Colors.blue;
    followPaint.style = PaintingStyle.stroke;
    followPaint.strokeWidth = 4;
    borderPaint.color = Colors.black;
    borderPaint.style = PaintingStyle.fill;
    borderPaint.strokeWidth = 2;

    xMax = dataList.map<double>((e) => e.x).toList().reduce(max);
    yMax = dataList.map<double>((e) => e.y).toList().reduce(max);

    xSum = dataList.map<double>((e) => e.x).toList().sum;
    ySum = dataList.map<double>((e) => e.y).toList().sum;

    xSpacing = chartWidth / xMax;
    ySpacing = chartHeight / yMax;

    // for (int i = 0; i < dataList.length; i++){
    //   print('begin : ${i == 0 ? 0 : dataList.length / i}, end : ${i == dataList.length - 1 ? 1 : 1 / dataList.length}');
    // }
    xBegin = dataList[0].x / xMax;
    xEnd = dataList[0].y / yMax;
    tSequence = TweenSequence(
      <TweenSequenceItem<double>>[
        for (int i = 0; i < dataList.length; i++) ...[
          _makeTween(dataList[i], i, dataList.length),
          // TweenSequenceItem<double>(
          //   tween: Tween<double>(
          //     begin: i * 0.1,
          //     end: i * 0.1 + 0.1,
          //     // begin: i == 0 ? 0 : dataList.length / i,
          //     // end: i == dataList.length - 1 ? 1 : dataList.length / i + 1,
          //   ).chain(CurveTween(curve: Curves.easeOut)),
          //   weight: 10,
          // ),
        ],
      ],
    );

    // for (var data in dataList) {
    //   followPath.lineTo(data.x * xSpacing, (data.y * ySpacing) * -1);
    //   pointList.add(Offset(data.x * xSpacing, (data.y * ySpacing) * -1));
    // }
  }

  double xBegin = 0;
  double xEnd = 0;
  double yBegin = 0;
  double yEnd = 0;

  double begin = 0;
  double end = 0;

  TweenSequenceItem<double> _makeTween(Data data, int i, int totalLength) {
    begin = end;
    end = ((data.x + data.y) / 2) / ((xMax + yMax) / 2);

    xBegin = xEnd;
    yBegin = yEnd;

    /// 최대값에서 현재 값의 비율만 구하면 된다.
    xEnd = data.x / xMax;
    yEnd = data.y / yMax;
    print('begin : $begin, end : $end');
    // print('xBegin : $xBegin, xEnd : $xEnd');
    // print('yBegin : $yBegin, yEnd : $yEnd');

    return TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: begin,
        end: end,
      ).chain(CurveTween(curve: Curves.easeIn)),
      weight: 10,
    );
    // .chain(CurveTween(curve: const SineCurve()))
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
                builder: (_, child) {
                  final val = tSequence.evaluate(_animationController);
                  // final val = linearTween.evaluate(_animationController);
                  print('val : $val');

                  /// 400사이즈에서 0에서 0.5에 도달하면 200이 된다.
                  /// 그러면 val의 값이 0.5가 나오도록 해야한다.
                  /// tween의 begin : 0 end : 0.5의 값이 나오면 된다.

                  followPath.lineTo(_animationController.value * chartWidth,
                      -val * chartHeight);

                  // for (var data in dataList) {
                  //   followPath.lineTo(data.x * xSpacing, (data.y * ySpacing) * -1);
                  //   pointList.add(Offset(data.x * xSpacing, (data.y * ySpacing) * -1));
                  // }
                  return SizedBox(
                    width: 400,
                    height: 400,
                    child: CustomPaint(
                      painter: FourthPainter(
                        followPath: followPath,
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
                  _animationController.forward();
                },
                child: const Text("start"))
          ],
        ),
      ),
    );
  }
}
