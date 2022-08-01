import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:various_animation/painter/j_painter.dart';
import 'package:various_animation/test/AnimationAndCurve.dart';

import '../AnimationScreen.dart';

class MyAnimationScreen extends StatefulWidget {
  const MyAnimationScreen({Key? key}) : super(key: key);

  @override
  _MyAnimationScreenState createState() => _MyAnimationScreenState();
}

class _MyAnimationScreenState extends State<MyAnimationScreen> {
  static final linearTween = Tween<double>(begin: 0, end: 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("")),
      body: AnimationAndCurve(
        label: "first",
        mainCurve: linearTween
            .chain(CurveTween(curve: Curves.easeIn))
            .chain(CurveTween(curve: Curves.easeOut)),
        duration: const Duration(seconds: 2),
        size: 200,
      ),
    );
  }
}

enum KindOfAnimation {
  forward,
  repeat,
  repeatAndReverse,
}

class AnimationAndCurve extends StatefulWidget {
  final Animatable<double> mainCurve;
  final Animatable<double>? compareCurve;
  final String label;
  final double size;
  final Duration duration;
  final KindOfAnimation kindOfAnimation;

  const AnimationAndCurve(
      {required this.mainCurve,
      this.compareCurve,
      this.label = "",
      this.size = 200,
      this.duration = const Duration(seconds: 1),
      this.kindOfAnimation = KindOfAnimation.forward,
      Key? key})
      : super(key: key);

  @override
  _AnimationAndCurveState createState() => _AnimationAndCurveState();
}

class _AnimationAndCurveState extends State<AnimationAndCurve>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  Animatable<double> get _mainCurve => widget.mainCurve;

  Animatable<double>? get _compareCurve => widget.compareCurve;

  String get _label => widget.label;

  double get _size => widget.size;

  Duration get _duration => widget.duration;

  KindOfAnimation get _kindOfAnimation => widget.kindOfAnimation;

  late Path _shadowPath;

  Path? _comparePath;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: _duration);
    // if (_compareCurve != null) {
    //   _comparePath = _buildGraph(_compareCurve!);
    // }
    super.initState();
  }

  Path _buildGraph(Animatable<double> animatable) {
    var val = 0.0;
    var path = Path();
    for (var t = 0 / 0; t <= 1; t += 0.01) {
      val = -animatable.transform(t) * _size;
      path.lineTo(t * _size, val);
    }
    return path;
  }

  _playAnimation() {
    _animationController.reset();
    if (_kindOfAnimation == KindOfAnimation.forward) {
      _animationController.forward();
    } else if (_kindOfAnimation == KindOfAnimation.repeat) {
      _animationController.repeat();
    } else {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var intervalValue = 0.0;
    var followPath = Path();
    return Column(
      children: [
        // Text(_label),
        // Expanded(
        //   child: AnimatedBuilder(
        //     animation: _animationController,
        //     builder: (context, child) {
        //       /// Alignment에서 x, y 값 좌표
        //       /// -1,-1 ㅣ  0,-1 ㅣ 1,-1
        //       /// -1,0  ㅣ  0,0  ㅣ 1,0
        //       /// -1,1  ㅣ  0,1  ㅣ 1,1
        //       return Align(
        //         alignment: Alignment(
        //           lerpDouble(-1, 1, _mainCurve.evaluate(_animationController))!,
        //           0,
        //         ),
        //         child: child,
        //       );
        //     },
        //     child: const SizedBox(
        //       width: 100,
        //       height: 100,
        //       child: Icon(Icons.star),
        //     ),
        //   ),
        // ),
        SizedBox(
          height: 300,
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (_, child) {
              /// intervalValue 값이 _animationController.value 보다 크다는 것은
              /// 애니메이션이 끝났다는 것이다
              /// 애니메이션을 실행하는 도중에는 _animationController.value 값이 항상 크다.
              /// 그런데 애니메이션이 종료된 상태에서 intervalValue는 1이 될 것이고,
              /// _animationController.value 값은 0부터 다시 시작한다.
              if (intervalValue >= _animationController.value) {
                followPath.reset();
              }
              intervalValue = _animationController.value;


              /// _animationController.value 값은 animation begin ~ end 사이의 값을 duration으로 계산한 것이다.
              /// _mainCurve.evaluate(_animationController) 값은
              /// Animatable class 즉 subclass인 Tween 클래스에서 CurveTween의 값들을 고려한 계산이다
              /// CurveTween의 값을 계산하면 animation이 실행되는 시간 내에서 특정구간들의 속도를 컨트롤 할 수 있다.
              final val = _mainCurve.evaluate(_animationController);
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
              return CustomPaint(
                painter: JPainter(
                  followPath: followPath,
                  currentPoint: Offset(
                    _animationController.value * _size,
                    val * _size,
                  ),
                  chartSize: _size,
                  backgroundPaint: Paint()..color = Colors.white,
                  // backgroundPaint: Paint()..color = Colors.grey[200]!,
                  pointPaint: Paint()..color = Colors.red,
                  borderPaint: borderPaint,
                  followPaint: followPaint,
                ),
                child: Container(),
              );
            },
          ),
        ),

        SizedBox(height: 50),
        ElevatedButton(
            onPressed: _playAnimation, child: const Text("시작")),

      ],
    );
  }
}
