import 'package:flutter/material.dart';
import 'package:messman/includes/providers.dart';
import 'package:messman/includes/routes.dart';
import 'package:messman/includes/theme_data.dart';
import 'package:messman/screens/wrapper.dart';
import 'package:provider/provider.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: messManProviders,
      child: MessApp(),
    );
  }
}

class MessApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: messManThemeData,
      debugShowCheckedModeBanner: false,
      title: 'MessMan',
      home: Wrapper(),
      routes: messManRoutes,
    );
  }
}
