import 'dart:math';

import 'package:flutter/material.dart';

class MembersCircleAvatar extends StatelessWidget {
  final String imageUrl;
  final String firstChar;
  final double radius;
  const MembersCircleAvatar({
    Key key,
    this.imageUrl,
    this.firstChar,
    this.radius = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = [
      Colors.redAccent,
      Colors.blueAccent,
      Colors.greenAccent,
      Colors.orangeAccent,
      Colors.yellowAccent,
      Colors.tealAccent
    ];
    final rand = Random();

    return CircleAvatar(
      radius: radius,
      backgroundColor: colors[rand.nextInt(colors.length)],
      child: ClipOval(
        child: Image.network(
          imageUrl ?? '',
          errorBuilder: (ctx, child, trace) {
            return Text(
              firstChar.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: radius / 2 < 15 ? 15 : radius / 2,
              ),
            );
          },
          height: 58,
          width: 58,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class MembersSquareAvatar extends StatelessWidget {
  final String imageUrl;
  final String firstChar;
  final double radius;
  const MembersSquareAvatar({
    Key key,
    this.imageUrl,
    this.firstChar,
    this.radius = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: radius,
      width: radius,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Image.network(
        imageUrl ?? '',
        errorBuilder: (ctx, child, trace) {
          return Center(
            child: Text(
              firstChar.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: radius / 3 < 12 ? 12 : radius / 3,
              ),
            ),
          );
        },
        height: 58,
        width: 58,
        fit: BoxFit.cover,
      ),
    );
  }
}
