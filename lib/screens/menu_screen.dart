import 'package:animations/screens/apple_watch_screen.dart';
import 'package:animations/screens/explicit_animations_screen.dart';
import 'package:animations/screens/implicit_animations_screen.dart';
import 'package:animations/screens/swiping_card_screen.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  void _goToPage(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Animation Master Class"),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                _goToPage(
                  context,
                  const ImplicitAnimationScreen(),
                );
              },
              child: const Text("Implicit Animations"),
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(
                  context,
                  const ExplicitAnimationScreen(),
                );
              },
              child: const Text("Explicit Animations"),
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(
                  context,
                  const AppleWatchScreen(),
                );
              },
              child: const Text("AppleWatch Animations"),
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(
                    context,
                    // const SwipingCardScreen(),
                    const SwipingCardScreen());
              },
              child: const Text("Swiping Card"),
            ),
          ],
        ),
      ),
    );
  }
}
