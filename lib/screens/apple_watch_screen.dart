import 'dart:math';

import 'package:flutter/material.dart';

class AppleWatchScreen extends StatefulWidget {
  const AppleWatchScreen({super.key});

  @override
  State<AppleWatchScreen> createState() => _AppleWatchScreenState();
}

class _AppleWatchScreenState extends State<AppleWatchScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(
      milliseconds: 2000,
    ),
  )..forward();

  late final CurvedAnimation _curve = CurvedAnimation(
    parent: _animationController,
    curve: Curves.bounceOut,
  );

  List<double> initRandomValues =
      List.generate(3, (index) => Random().nextDouble() * 2.0);

  late List<Animation<double>> progressList = List.generate(
    3,
    (index) => Tween(
      begin: 0.005,
      end: initRandomValues[index],
    ).animate(
      _curve,
    ),
  );

  void _animateValues() {
    List<double> newBeginPoints =
        List.generate(3, (index) => progressList[index].value);

    List<double> randomNumbers =
        List.generate(3, (index) => Random().nextDouble() * 2);

    List<double> newEndPoints = List.generate(3, (index) => 0.0);

    for (int i = 0; i < progressList.length; i++) {
      newEndPoints[i] = randomNumbers[i];
    }

    for (int i = 0; i < progressList.length; i++) {
      progressList[i] =
          Tween(begin: newBeginPoints[i], end: newEndPoints[i]).animate(_curve);
    }

    setState(() {});
    _animationController.forward(from: 0);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Apple Watch"),
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: progressList[0],
          // Listenable.merge(progressList),
          builder: (context, child) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomPaint(
                painter: AppleWatchPainter(
                  progressRed: progressList[0].value,
                  progressGreen: progressList[1].value,
                  progressBlue: progressList[2].value,
                ),
                size: const Size(
                  350,
                  350,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _animateValues,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class AppleWatchPainter extends CustomPainter {
  final double progressRed;
  final double progressGreen;
  final double progressBlue;

  AppleWatchPainter({
    required this.progressRed,
    required this.progressGreen,
    required this.progressBlue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const startAngle = -0.5 * pi;

    final redCirclePaint = Paint()
      ..color = Colors.red.shade500.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;
    final redCircleRadius = (size.width / 2) * 0.9;
    canvas.drawCircle(center, redCircleRadius, redCirclePaint);

    final greenCirclePaint = Paint()
      ..color = Colors.green.shade500.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;
    final greenCircleRadius = (size.width / 2) * 0.73;
    canvas.drawCircle(center, greenCircleRadius, greenCirclePaint);

    final blueCirclePaint = Paint()
      ..color = Colors.blue.shade500.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;
    final blueCircleRadius = (size.width / 2) * 0.56;
    canvas.drawCircle(center, blueCircleRadius, blueCirclePaint);

    final redArcRect = Rect.fromCircle(center: center, radius: redCircleRadius);
    final redArcPaint = Paint()
      ..color = Colors.red.shade400
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 25;
    canvas.drawArc(
      redArcRect,
      startAngle,
      progressRed * pi,
      false,
      redArcPaint,
    );

    final greenArcRect =
        Rect.fromCircle(center: center, radius: greenCircleRadius);
    final greenArcPaint = Paint()
      ..color = Colors.green.shade400
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 25;
    canvas.drawArc(
      greenArcRect,
      startAngle,
      progressGreen * pi,
      false,
      greenArcPaint,
    );

    final blueArcRect =
        Rect.fromCircle(center: center, radius: blueCircleRadius);
    final blueArcPaint = Paint()
      ..color = Colors.blue.shade400
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 25;
    canvas.drawArc(
      blueArcRect,
      startAngle,
      progressBlue * pi,
      false,
      blueArcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant AppleWatchPainter oldDelegate) {
    return oldDelegate.progressRed != progressRed ||
        oldDelegate.progressGreen != progressGreen ||
        oldDelegate.progressBlue != progressBlue;
  }
}
