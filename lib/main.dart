import 'package:band_names/services/socket_server.dart';
import 'package:flutter/material.dart';

import 'package:band_names/pages/pages.dart';
import 'package:band_names/pages/status.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => SocketServer(),
          ),
        ],
        builder: (context, snapshot) {
          return MaterialApp(
            title: 'Material App',
            debugShowCheckedModeBanner: false,
            initialRoute: HomePage.route,
            routes: {
              HomePage.route: (_) => HomePage(),
              StatusPage.route: (_) => StatusPage()
            },
          );
        });
  }
}
