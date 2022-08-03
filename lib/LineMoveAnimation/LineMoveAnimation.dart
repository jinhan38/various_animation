import 'package:flutter/material.dart';
import 'package:various_animation/LineMoveAnimation/LineMovePainter.dart';

class LineMoveAnimation extends StatefulWidget {
  const LineMoveAnimation({Key? key}) : super(key: key);

  @override
  _LineMoveAnimationState createState() => _LineMoveAnimationState();
}

class _LineMoveAnimationState extends State<LineMoveAnimation>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animationController;

  List<Offset> offsets = [];

  @override
  void initState() {
    super.initState();
    offsets.add(const Offset(5, 10));
    offsets.add(const Offset(10, 40));
    offsets.add(const Offset(90, 60));
    offsets.add(const Offset(70, 70));
    offsets.add(const Offset(130, 90));
    offsets.add(const Offset(160, 95));

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    Tween<double> tween =
        Tween<double>(begin: 0, end: offsets.length.toDouble());
    animation = tween.animate(animationController);

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.repeat();
      } else if (status == AnimationStatus.dismissed) {
        animationController.forward();
      }
    });

    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
                animation: animationController,
                builder: (_, child) {
                  return Center(
                    child: Container(
                      color: Colors.green.shade200,
                      width: 200,
                      height: 200,
                      child: CustomPaint(
                        foregroundPainter: LineMovePainter(
                          animationController.value,
                          offsets,
                        ),
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
