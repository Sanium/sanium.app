import 'package:flutter/material.dart';

class RotateTrans extends StatelessWidget {
  final Widget child;
  final Animation<double> animation;
  RotateTrans(this.child, this.animation);
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        return Container(
          child: Transform.rotate(
            angle: animation.value,
            child: Container(
              child: child,
            ),
          ),
        );
      },
    );
  }
}