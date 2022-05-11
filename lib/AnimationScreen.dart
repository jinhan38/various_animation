import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:various_animation/painter/j_painter.dart';

import 'curves/sine_curve.dart';
import 'curves/spring_curve.dart';
import 'tween/custom_tween.dart';

class AnimationScreen extends StatelessWidget {
  const AnimationScreen({Key? key}) : super(key: key);

  /// NOTE: A tween<double> can have a [Tween.begin] and [Tween.end] of any
  /// double value, however for the demo purposes these values will be
  /// constrained between 0 and 1 (begin: 0, end: 1).
  ///
  /// This is only to facilitate the logic of the [AnimationAndCurveDemo]
  /// LINEAR TWEEN - straight line
  static final linearTween = Tween<double>(begin: 0, end: 1);

  /// SEQUENCE TWEEN - combine a sequence of tweens into one
  static final tweenSequence = TweenSequence(
    <TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0, end: 1.0).chain(CurveTween(curve: Curves.easeOut)),
        weight: 40.0,
      ),
      TweenSequenceItem<double>(
        tween: ConstantTween<double>(1.0),
        weight: 20.0,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1.0, end: 0).chain(CurveTween(curve: Curves.easeIn)),
        weight: 40.0,
      ),
    ],
  );

  /// CHAIN TWEEN EXAMPLE (Note: the [chainTween] goes from 0 to 2, not 0 to 1)
  static final Tween<double> chainTween = Tween<double>(begin: 0, end: 2);

  /// CONSTANT TWEEN - tween with a constant value
  static final constantTween = ConstantTween<double>(1.0);

  /// SAW TOOTH TWEEN - tween that goes from 0 to 1 multiple times,
  /// depending on the value passed in
  static const Curve sawToothCurve = SawTooth(7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PageView(
        children: <Widget>[
          AnimationAndCurveDemo(
            label: 'Linear - EaseIn and EaseOut',
            mainCurve: linearTween.chain(CurveTween(curve: Curves.easeIn)).chain(CurveTween(curve: Curves.easeOut)),
            duration: const Duration(seconds: 2),
            size: 200,
          ),
          AnimationAndCurveDemo(
            label: 'Linear - SawTooth',
            mainCurve: linearTween.chain(CurveTween(curve: Curves.bounceOut)).chain(CurveTween(curve: sawToothCurve)),
            duration: const Duration(seconds: 7),
            size: 200,
          ),
          AnimationAndCurveDemo(
            label: 'Linear - 0 to 2',
            mainCurve: linearTween.chain(chainTween),
            duration: const Duration(seconds: 1),
            size: 200,
          ),
          AnimationAndCurveDemo(
            label: 'Tween Sequence',
            mainCurve: tweenSequence,
            compareCurve: linearTween,
            kindOfAnimation: KindOfAnimation.repeat,
          ),
          AnimationAndCurveDemo(
            label: 'Custom Curve: Sine',
            mainCurve: linearTween.chain(CurveTween(curve: const SineCurve())),
            duration: const Duration(seconds: 4),
            kindOfAnimation: KindOfAnimation.repeat,
            size: 200,
          ),
          AnimationAndCurveDemo(
            label: 'Custom Curve: Springy',
            mainCurve: linearTween.chain(CurveTween(curve: const SpringCurve())),
            duration: const Duration(seconds: 3),
            size: 200,
          ),
          AnimationAndCurveDemo(
            label: 'Custom Tween: Blocky',
            mainCurve: CustomTween(begin: 0, end: 1),
            duration: const Duration(seconds: 1),
            size: 200,
          ),
        ],
      ),
    );
  }
}

enum KindOfAnimation {
  forward,
  repeat,
  repeatAndReverse,
}

class AnimationAndCurveDemo extends StatefulWidget {
  final Animatable<double> mainCurve;
  final Animatable<double>? compareCurve;
  final String label;
  final double size;
  final Duration duration;
  final KindOfAnimation kindOfAnimation;

  AnimationAndCurveDemo({
    required this.mainCurve,
    this.compareCurve,
    this.label = "",
    this.size = 200,
    this.duration = const Duration(seconds: 1),
    this.kindOfAnimation = KindOfAnimation.forward,
    Key? key,
  }) : super(key: key);

  @override
  _AnimationAndCurveDemoState createState() => _AnimationAndCurveDemoState();
}

class _AnimationAndCurveDemoState extends State<AnimationAndCurveDemo> with SingleTickerProviderStateMixin {
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
    super.initState();
    print('_mainCurve : $_mainCurve');

    _animationController = AnimationController(vsync: this, duration: _duration);
    _shadowPath = _buildGraph(_mainCurve);
    if (_compareCurve != null) {
      _comparePath = _buildGraph(_compareCurve!);
    }
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
        Padding(
          padding: EdgeInsets.all(8),
          child: Text(_label),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Align(
                  alignment: Alignment(
                    lerpDouble(-1, 1, _mainCurve.evaluate(_animationController))!,
                    0,
                  ),
                  child: child,
                );
              },
              child: const SizedBox(
                width: 100,
                height: 100,
                child: Icon(Icons.star),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: _playAnimation,
            child: const Text('Tween'),
          ),
        ),
        SizedBox(
          height: 300,
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (_, child) {
              if (intervalValue >= _animationController.value) {
                followPath.reset();
              }
              intervalValue = _animationController.value;

              final val = _mainCurve.evaluate(_animationController);
              followPath.lineTo(_animationController.value * _size, -val * _size);

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
                  backgroundPaint: Paint()..color = Colors.grey[200]!,
                  pointPaint: Paint()..color = Colors.red,
                  borderPaint: borderPaint,
                  followPaint: followPaint,
                ),
                child: Container(),
              );
            },
          ),
        ),
      ],
    );
  }
}
