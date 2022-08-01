import 'package:flutter/material.dart';
import 'package:various_animation/circleAnimation/CircleAnimation.dart';
import 'package:various_animation/fourthChart/FourthChart.dart';
import 'package:various_animation/newChart/NewChartScreen.dart';
import 'package:various_animation/test/MyAnimationScreen.dart';

import 'AnimationScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
      // home: const AnimationScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AnimationScreen()),
                    );
                  },
                  child: const Text("Fist")),
              const SizedBox(height: 100),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyAnimationScreen()),
                    );
                  },
                  child: const Text("Second")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NewChartScreen(
                                mainCurve: tweenSequence,
                                size: MediaQuery.of(context).size.width - 100,
                              )),
                    );
                  },
                  child: const Text("Third")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FourthChart()),
                    );
                  },
                  child: const Text("Fourth")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CircleAnimation()),
                    );
                  },
                  child: const Text("CircleAnimation")),
            ],
          ),
        ),
      ),
    );
  }
}
