import 'package:flutter/material.dart';

class ExplicitAnimationScreen extends StatefulWidget {
  const ExplicitAnimationScreen({super.key});

  @override
  State<ExplicitAnimationScreen> createState() =>
      _ExplicitAnimationScreenState();
}

class _ExplicitAnimationScreenState extends State<ExplicitAnimationScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 2,
      ),
      reverseDuration: const Duration(
        seconds: 2,
      )
      // lowerBound: 50.0,
      // upperBound: 100.0,
      )
    ..addListener(() {
      _range.value = _animationController.value;
    })
    ..addStatusListener((status) {});
  // 애니메이션이 완료, 종료 상태에 따라 작업을 수행 할 수 있음 일짃

  late final Animation<double> _rotation = Tween(
    begin: 0.0,
    end: 1.0,
  ).animate(_curvedAnimation);

  late final Animation<double> _scale = Tween(
    begin: 1.0,
    end: 1.2,
  ).animate(_curvedAnimation);

  late final Animation<Offset> _slide = Tween(
    begin: Offset.zero,
    end: const Offset(0, -0.5),
  ).animate(_curvedAnimation);

  late final CurvedAnimation _curvedAnimation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.elasticOut,
    // reverseCurve: Curves.easeOut,
  );

  late final Animation<Decoration> _decoration = DecorationTween(
    begin: BoxDecoration(
      color: Colors.amber,
      borderRadius: BorderRadius.circular(20),
    ),
    end: BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(120),
    ),
  ).animate(_animationController);

  void _play() {
    _animationController.forward();
  }

  void _pause() {
    _animationController.stop();
  }

  void _reverse() {
    _animationController.reverse();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }

  final ValueNotifier<double> _range = ValueNotifier(0.0);

  void _onChanged(double value) {
    _range.value = 0.0;
    // _animationController.animateTo(value);
    _animationController.value = value;
  }

  bool _looping = false;

  void _toggleLooping() {
    if (_looping) {
      _animationController.stop();
    } else {
      _animationController.repeat(
        reverse: true,
      );
    }
    setState(() {
      _looping = !_looping;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Build UI");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Explicit Animation Screen"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideTransition(
              position: _slide,
              child: ScaleTransition(
                scale: _scale,
                child: RotationTransition(
                  turns: _rotation,
                  child: DecoratedBoxTransition(
                    decoration: _decoration,
                    child: const SizedBox(
                      height: 300,
                      width: 300,
                    ),
                  ),
                ),
              ),
            ),
            // AnimatedBuilder(
            //   animation: _color,
            //   builder: (context, child) => Container(
            //     color: _color.value,
            //     width: 400,
            //     height: 400,
            //     child: Text(
            //       "${_animationController.value}",
            //       style: const TextStyle(
            //         fontSize: 58,
            //       ),
            //     ),
            //   ),
            // ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: _play, child: const Text('Play')),
                ElevatedButton(onPressed: _pause, child: const Text('Pause')),
                ElevatedButton(
                    onPressed: _reverse, child: const Text('Reverse')),
                ElevatedButton(
                  onPressed: _toggleLooping,
                  child: Text(_looping ? "Stop" : 'Repeat'),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            ValueListenableBuilder(
              valueListenable: _range,
              builder: (context, value, child) => Slider(
                value: value,
                onChanged: _onChanged,
              ),
            )
          ],
        ),
      ),
    );
  }
}
