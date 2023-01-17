import 'package:flutter/material.dart';
import 'dart:math' as math;

class CircularProgressBar extends StatefulWidget {
  const CircularProgressBar(
      {Key? key,
      this.radius,
      required this.ratio,
        required this.size,
      this.backgroundColor,
      this.progressColor})
      : super(key: key);
  final double? radius;
  final double? ratio;
  final double? size;
  final Color? progressColor;
  final Color? backgroundColor;

  @override
  _CircularProgressBarState createState() => _CircularProgressBarState();
}

class _CircularProgressBarState extends State<CircularProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation animation;

  final ValueNotifier<double> progressRatio = ValueNotifier<double>(0.0); //
  final double radius = 40;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(
        milliseconds: 1300,
      ),
      vsync: this,
    );
    animation = Tween<double>(begin: 0, end: widget.ratio).animate(animationController)
      ..addListener(progressListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      animationController.forward();
    });
  }

  void progressListener() {
    final value = (animation.value) ?? 0;
    if (value > 0) {
      progressRatio.value = value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: widget.size ?? 200,
      height: widget.size ?? 200,
      child: ValueListenableBuilder(
        valueListenable: progressRatio,
        builder: (BuildContext context, double value, Widget? child){
          return CustomPaint(
            painter: ArcPainter(radius: (widget.size ?? 200) * 0.5,percentage: (animation.value)),
            child: percentInfo(),
          );
        },
      )
    );
  }

  Widget percentInfo() {
    return ValueListenableBuilder(
      valueListenable: progressRatio, // 사용할 변수를 지정.
      builder: (BuildContext context, double value, Widget? child) {
        // value = _counter 로 적용
        return RichText(
            text: TextSpan(children: [
          TextSpan(
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  letterSpacing: -0.5,
                  height: 1.2),
              text: progressRatio.value.toStringAsFixed(0)),
          const TextSpan(
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  letterSpacing: -0.5,
                  height: 1.2),
              text: '%')
        ]));
      },
    );
  }
}

Paint createPaintForColor(Color color) {
  return Paint()
    ..color = color
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke
    ..strokeWidth = 15;
}
class ArcPainter extends CustomPainter {
  final double radius;
  final double percentage;
  final Color? progressColor;
  final Color? backgroundColor;
  final Paint red = createPaintForColor(Colors.red);
  final Paint blue = createPaintForColor(Colors.blue);
  final Paint green = createPaintForColor(Colors.grey.withOpacity(0.1));
//
  ArcPainter(
      {required this.radius,
      required this.percentage,
      this.progressColor,
      this.backgroundColor});

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2), radius: radius);

    canvas.drawArc(rect, -(math.pi / 2), sweepAngle(), false, blue);
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, green);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  double sweepAngle() => 2 * (percentage/100) * math.pi;
}
