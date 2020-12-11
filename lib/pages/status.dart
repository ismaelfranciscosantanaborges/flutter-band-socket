import 'package:band_names/services/socket_server.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatelessWidget {
  static final String route = 'status';

  @override
  Widget build(BuildContext context) {
    final _socketProvider = Provider.of<SocketServer>(context);

    return Scaffold(
      body: Center(
        child: Text('Status: ${_socketProvider.serverStatus}'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _socketProvider.emit(
          'emitir-mensaje',
          {'nombre': 'Flutter', 'mesaje': 'Hello from Flutter'},
        ),
        child: Icon(Icons.message),
      ),
    );
  }
}
