import 'package:flutter/material.dart';
import 'package:various_animation/myCircleAnimation/painter/CirclePainter.dart';
import 'dart:math' as math;

import 'package:various_animation/myCircleAnimation/painter/CirclePointerPainter.dart';

class MyCircleAnimation extends StatefulWidget {
  const MyCircleAnimation({Key? key}) : super(key: key);

  @override
  _MyCircleAnimationState createState() => _MyCircleAnimationState();
}

class _MyCircleAnimationState extends State<MyCircleAnimation>
    with SingleTickerProviderStateMixin {
  var _radius = 100.0;

  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 8),
    );

    Tween<double> _rotationTween = Tween(begin: -math.pi, end: math.pi);
    animation = _rotationTween.animate(controller);
    animation.addListener(() {
      setState(() {});
    });
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.repeat();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:Center(
          child: Container(
            child: CustomPaint(
              foregroundPainter: CirclePointerPainter(_radius, animation.value),
              painter: CirclePainter(100),
              child: Container(
                width: 200,height: 200,
              ),
            ),
          ),
        )
      ),
    );
  }
}
