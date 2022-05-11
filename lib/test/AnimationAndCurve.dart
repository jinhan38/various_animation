// import 'dart:ui';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:various_animation/painter/j_painter.dart';
//
// enum KindOfAnimation {
//   forward,
//   repeat,
//   repeatAndReverse,
// }
//
// class AnimationAndCurve extends StatefulWidget {
//   final Animatable<double> mainCurve;
//   final Animatable<double>? compareCurve;
//   final String label;
//   final double size;
//   final Duration duration;
//   final KindOfAnimation kindOfAnimation;
//
//   const AnimationAndCurve(
//       {required this.mainCurve,
//       this.compareCurve,
//       this.label = "",
//       this.size = 200,
//       this.duration = const Duration(seconds: 1),
//       this.kindOfAnimation = KindOfAnimation.forward,
//       Key? key})
//       : super(key: key);
//
//   @override
//   _AnimationAndCurveState createState() => _AnimationAndCurveState();
// }
//
// class _AnimationAndCurveState extends State<AnimationAndCurve>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//
//   Animatable<double> get _mainCurve => widget.mainCurve;
//
//   Animatable<double>? get _compareCurve => widget.compareCurve;
//
//   String get _label => widget.label;
//
//   double get _size => widget.size;
//
//   Duration get _duration => widget.duration;
//
//   KindOfAnimation get _kindOfAnimation => widget.kindOfAnimation;
//
//   @override
//   void initState() {
//     print('_mainCurve 22 : $_mainCurve');
//     _animationController =
//         AnimationController(vsync: this, duration: _duration);
//     super.initState();
//   }
//
//   _playAnimation() {
//     print('_playAnimation');
//     _animationController.reset();
//     if (_kindOfAnimation == KindOfAnimation.forward) {
//     } else if (_kindOfAnimation == KindOfAnimation.repeat) {
//       _animationController.repeat();
//     } else {
//       _animationController.repeat(reverse: true);
//     }
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var intervalValue = 0.0;
//     var followPath = Path();
//     return Column(
//       children: [
//         Text(_label),
//         Expanded(
//           child: AnimatedBuilder(
//             animation: _animationController,
//             builder: (context, child) {
//               return Align(
//                 alignment: Alignment(
//                   lerpDouble(-1, 1, _mainCurve.evaluate(_animationController))!,
//                   0,
//                 ),
//                 child: child,
//               );
//             },
//             child: const SizedBox(
//               width: 100,
//               height: 100,
//               child: Icon(Icons.star),
//             ),
//           ),
//         ),
//         ElevatedButton(
//             onPressed: _playAnimation, child: const Text("애니메이션 시작")),
//         SizedBox(
//           height: 300,
//           child: AnimatedBuilder(
//             animation: _animationController,
//             builder: (_, child) {
//               if (intervalValue >= _animationController.value) {
//                 followPath.reset();
//               }
//               intervalValue = _animationController.value;
//
//               final val = _mainCurve.evaluate(_animationController);
//               followPath.lineTo(
//                   _animationController.value * _size, -val * _size);
//
//               Paint followPaint = Paint();
//               followPaint.color = Colors.blue;
//               followPaint.style = PaintingStyle.stroke;
//               followPaint.strokeWidth = 4;
//               Paint borderPaint = Paint();
//               borderPaint.color = Colors.black;
//               borderPaint.style = PaintingStyle.fill;
//               borderPaint.strokeWidth = 2;
//               return CustomPaint(
//                 painter: JPainter(
//                   followPath: followPath,
//                   currentPoint: Offset(
//                     _animationController.value * _size,
//                     val * _size,
//                   ),
//                   chartSize: _size,
//                   backgroundPaint: Paint()..color = Colors.grey[200]!,
//                   pointPaint: Paint()..color = Colors.red,
//                   borderPaint: borderPaint,
//                   followPaint: followPaint,
//                 ),
//                 child: Container(),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
