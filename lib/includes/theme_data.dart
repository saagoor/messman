import 'package:flutter/material.dart';

var messManThemeData = ThemeData(
  fontFamily: 'ProductSans',
  primarySwatch: Colors.lightBlue,
  textTheme: TextTheme(
    bodyText1: TextStyle(fontSize: 16),
    bodyText2: TextStyle(fontSize: 15),
    headline1: TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.normal,
      color: Colors.black87,
    ),
    headline2: TextStyle(fontSize: 22),
    headline3: TextStyle(fontSize: 18),
  ),
  cardTheme: CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.2)),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey.shade100),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    contentPadding: EdgeInsets.all(10),
  ),
);
