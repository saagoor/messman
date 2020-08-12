import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NetworkCircleAvatar extends StatelessWidget {
  const NetworkCircleAvatar({
    Key key,
    @required this.imageUrl,
    this.size = 60,
    this.firstChar,
    this.color,
  }) : super(key: key);

  final String imageUrl;
  final double size;
  final String firstChar;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).primaryColorLight,
        shape: BoxShape.circle,
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
                    fontSize: size / 2.5 < 15 ? 15 : size / 2.5,
                  ),
                ),
              )
            : Icon(Icons.error),
        fit: BoxFit.cover,
      ),
    );
  }
}
