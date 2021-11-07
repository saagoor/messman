import 'package:flutter/material.dart';

class NoScaffoldFAB extends StatelessWidget {
  final Widget child;
  final Function onPressed;
  final double bottom;
  final double right;
  const NoScaffoldFAB({
    Key key,
    this.child,
    this.onPressed,
    this.right = 15,
    this.bottom = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottom,
      right: right,
      height: 50,
      width: 50,
      child: FloatingActionButton(
        heroTag: key,
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
