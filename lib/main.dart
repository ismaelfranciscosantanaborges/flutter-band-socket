import 'package:flutter/material.dart';

import 'package:band_names/pages/pages.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      initialRoute: HomePage.route,
      routes: {HomePage.route: (_) => HomePage()},
    );
  }
}
