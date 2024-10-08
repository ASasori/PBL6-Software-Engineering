import 'package:flutter/material.dart';

class ListCellAnimationView extends StatelessWidget {
  final Animation<double> animation;
  final AnimationController animationController;
  final Widget child;
  final double yTranslation;

  const ListCellAnimationView({super.key, required this.animation, required this.animationController, required this.child, this.yTranslation = 50});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animation,
        child: child,
        builder: (context, child){
          return FadeTransition(
            opacity: animation,
            child: Transform(
              transform: Matrix4.translationValues(0.0, yTranslation * (1.0 - animation.value), 0.0),
              child: child,
            ),
          );
        }
    );
  }
}
