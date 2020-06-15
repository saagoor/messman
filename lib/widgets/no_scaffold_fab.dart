import 'package:flutter/material.dart';


class NoScaffoldFAB extends StatelessWidget {
  final Widget child;
  final Function onPressed;
  const NoScaffoldFAB({
    Key key,
    this.child,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      right: 15,
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