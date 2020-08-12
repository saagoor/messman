import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:messman/widgets/network_circle_avatar.dart';

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

    return NetworkCircleAvatar(
      imageUrl: imageUrl,
      size: 45,
      firstChar: firstChar,
      color: colors[rand.nextInt(colors.length)],
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
      clipBehavior: Clip.antiAlias,
      height: radius,
      width: radius,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: CachedNetworkImage(
        imageUrl: imageUrl ?? '',
        placeholder: (context, url) => Image.asset('assets/icons/icon.png'),
        errorWidget: (context, url, error) => firstChar != null
            ? Center(
                child: Text(
                  firstChar.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: radius / 2.5 < 15 ? 15 : radius / 2.5,
                  ),
                ),
              )
            : Icon(Icons.error),
        fit: BoxFit.cover,
      ),
    );
  }
}
