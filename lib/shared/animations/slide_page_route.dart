import 'package:flutter/material.dart';

class SlidePageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final AxisDirection direction;

  SlidePageRoute({
    required this.child,
    this.direction = AxisDirection.right,
    super.settings,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return _buildTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
              direction: direction,
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 450),
        );

  static Widget _buildTransition({
    required Animation<double> animation,
    required Animation<double> secondaryAnimation,
    required Widget child,
    required AxisDirection direction,
  }) {
    Offset begin;
    const Offset end = Offset.zero;
    
    switch (direction) {
      case AxisDirection.right:
        begin = const Offset(1.0, 0.0);
        break;
      case AxisDirection.left:
        begin = const Offset(-1.0, 0.0);
        break;
      case AxisDirection.up:
        begin = const Offset(0.0, -1.0);
        break;
      case AxisDirection.down:
        begin = const Offset(0.0, 1.0);
        break;
    }

    const primaryCurve = Curves.easeOutCubic;
    const secondaryCurve = Curves.easeInCubic;

    final slideAnimation = Tween<Offset>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: primaryCurve,
    ));

    final scaleAnimation = Tween<double>(
      begin: 0.92,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOutQuart),
    ));

    final fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    final secondarySlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(direction == AxisDirection.right ? -0.3 : 0.3, 0.0),
    ).animate(CurvedAnimation(
      parent: secondaryAnimation,
      curve: secondaryCurve,
    ));

    final secondaryScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: secondaryAnimation,
      curve: secondaryCurve,
    ));

    final secondaryFadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: secondaryAnimation,
      curve: const Interval(0.0, 0.8, curve: Curves.easeIn),
    ));

    return Stack(
      children: [
        SlideTransition(
          position: secondarySlideAnimation,
          child: ScaleTransition(
            scale: secondaryScaleAnimation,
            child: FadeTransition(
              opacity: secondaryFadeAnimation,
              child: Container(),
            ),
          ),
        ),
        SlideTransition(
          position: slideAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}
