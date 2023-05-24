import 'package:flutter/material.dart';

class ImplicitAnimationScreen extends StatefulWidget {
  const ImplicitAnimationScreen({super.key});

  @override
  State<ImplicitAnimationScreen> createState() =>
      _ImplicitAnimationScreenState();
}

class _ImplicitAnimationScreenState extends State<ImplicitAnimationScreen> {
  bool visible = true;
  void _trigger() {
    setState(() {
      visible = !visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Implict Animations"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder(
              tween: ColorTween(begin: Colors.purple, end: Colors.red),
              curve: Curves.bounceIn,
              duration: const Duration(seconds: 5),
              builder: (context, value, child) {
                return Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/4/4f/Dash%2C_the_mascot_of_the_Dart_programming_language.png',
                  color: value,
                  colorBlendMode: BlendMode.dstATop,
                );
              },
            ),
            // AnimatedContainer(
            //   curve: Curves.elasticInOut,
            //   duration: const Duration(seconds: 2),
            //   transform: Matrix4.rotationZ(visible ? 2 : 0),
            //   transformAlignment: Alignment.center,
            //   decoration: BoxDecoration(
            //       color: visible ? Colors.blueAccent.shade700 : Colors.amber,
            //       borderRadius: BorderRadius.circular(visible ? 100 : 0)),
            //   width: size.width * 0.8,
            //   height: size.width * 0.8,
            // ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(onPressed: _trigger, child: const Text("Go!"))
          ],
        ),
      ),
    );
  }
}
