import 'package:flutter/material.dart';

class HeroBackground extends StatelessWidget {
  final Widget child;
  final String heroTag;

  const HeroBackground({
    super.key,
    required this.child,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: child,
      ),
    );
  }
}
