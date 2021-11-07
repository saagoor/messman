import 'package:flutter/material.dart';

class ScreenLoading extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Theme.of(context).primaryColorLight.withOpacity(0.5),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}