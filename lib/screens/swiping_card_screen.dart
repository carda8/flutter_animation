import 'dart:math';

import 'package:flutter/material.dart';

class SwipingCardScreen extends StatefulWidget {
  const SwipingCardScreen({super.key});

  @override
  State<SwipingCardScreen> createState() => _SwipingCardScreenState();
}

class _SwipingCardScreenState extends State<SwipingCardScreen>
    with SingleTickerProviderStateMixin {
  late final size = MediaQuery.of(context).size;

  // animation controller is init by lowerbound

  late final AnimationController _position = AnimationController(
    vsync: this,
    duration: const Duration(
      seconds: 1,
    ),
    lowerBound: (size.width + 100) * -1,
    upperBound: (size.width + 100),
    value: 0.0,
  );

  late final Tween<double> _rotation = Tween(begin: -15, end: 15);

  late final Tween<double> _scale = Tween(begin: 0.8, end: 1.0);
  late final Tween<double> _scaleButton = Tween(begin: 1.0, end: 1.25);
  late final Tween<double> _scaleButtonBackground = Tween(begin: 0.4, end: 1.0);

  late final _colorCheckBackgroundTween =
      ColorTween(begin: Colors.white, end: Colors.green);
  late final _colorCloseBackgroundTween =
      ColorTween(begin: Colors.white, end: Colors.red);

  double posX = 0;

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _position.value += details.delta.dx;
    });
  }

  void _whenComplete() {
    setState(() {
      _position.value = 0;
      _index = _index == 5 ? 1 : _index + 1;
    });
  }

  late final dropZone = size.width + 100;

  void _onHorizontalDragEnd(DragEndDetails details) {
    final bound = size.width - 150;

    if (_position.value.abs() >= bound) {
      final factor = _position.value.isNegative ? -1 : 1;
      _position
          .animateTo(
            (dropZone) * factor,
            curve: Curves.easeOut,
          )
          .whenComplete(_whenComplete);
    } else {
      _position.animateTo(0, curve: Curves.easeOut);
    }
  }

  void _onTap(int factor) {
    if (!_position.isAnimating) {
      _position
          .animateTo(
            dropZone * factor,
            curve: Curves.easeOut,
          )
          .whenComplete(_whenComplete);
    }
  }

  void _onTapClose() {
    _onTap(-1);
  }

  void _onTapCheck() {
    _onTap(1);
  }

  @override
  void dispose() {
    _position.dispose();
    super.dispose();
  }

  int _index = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white60,
        title: const Text(
          "Swiping Cards",
        ),
      ),
      body: AnimatedBuilder(
        animation: _position,
        builder: (context, child) {
          final convertedValue = min(_position.value.abs() / (size.width), 1.0);
          final angle = _rotation
                  .transform((_position.value + size.width / 2) / size.width) *
              pi /
              180;
          final scale = _scale.transform(convertedValue);
          final scaleButoon = _scaleButton.transform(convertedValue);
          final scaleButtonBackground =
              _scaleButtonBackground.transform(convertedValue);
          final colorCheckBackground =
              _colorCheckBackgroundTween.transform(convertedValue);
          final colorCloseBackground =
              _colorCloseBackgroundTween.transform(convertedValue);
          return Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 100,
                child: Transform.scale(
                    scale: min(scale, 1.0),
                    child: Card(
                      index: _index == 5 ? 1 : _index + 1,
                    )),
              ),
              Positioned(
                top: 100,
                child: GestureDetector(
                  onHorizontalDragEnd: (details) =>
                      _onHorizontalDragEnd(details),
                  onHorizontalDragUpdate: (details) =>
                      _onHorizontalDragUpdate(details),
                  child: Transform.translate(
                    offset: Offset(_position.value, 0),
                    child: Transform.rotate(
                        angle: angle,
                        child: Card(
                          index: _index,
                        )),
                  ),
                ),
              ),
              Positioned(
                bottom: 50,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _onTapClose,
                      child: Transform.scale(
                        scale: _position.value < 0 ? scaleButoon : 1,
                        child: Material(
                          elevation: 10,
                          shape: const CircleBorder(),
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Transform.scale(
                                  scale: scaleButtonBackground,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: _position.value < 0
                                          ? colorCloseBackground
                                          : Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    width: 70,
                                    height: 70,
                                  ),
                                ),
                                Icon(
                                  Icons.close_rounded,
                                  size: 50,
                                  color: _position.value < 0
                                      ? Colors.white
                                      : Colors.red,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: _onTapCheck,
                      child: Transform.scale(
                        scale: _position.value > 0 ? scaleButoon : 1,
                        child: Material(
                          elevation: 10,
                          shape: const CircleBorder(),
                          child: Stack(
                            children: [
                              Transform.scale(
                                scale: scaleButtonBackground,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: _position.value > 0
                                        ? colorCheckBackground
                                        : Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  width: 70,
                                  height: 70,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.check_rounded,
                                    size: 50,
                                    color: _position.value > 0
                                        ? Colors.white
                                        : Colors.green),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class Card extends StatelessWidget {
  final int index;
  const Card({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: size.width * 0.8,
        height: size.height * 0.5,
        child: Image.asset(
          "assets/covers/img_$index.jpg",
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}
