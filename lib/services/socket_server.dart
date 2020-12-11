import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

enum ServerStatus {
  Online,
  Offline,
  Connecting,
}

class SocketServer with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;
  Function get emit => this._socket.emit;

  SocketServer() {
    this._initConfig();
  }

  _initConfig() {
    this._socket = IO.io('http://192.168.1.30:3000/', {
      'transports': ['websocket'],
      'autoConnect': true,
    });

    this._socket.on('connect', (_) {
      print('connect');
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    this._socket.on('disconnect', (_) {
      print('disconnect');
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    this._socket.on('refresh', (bands) {
      notifyListeners();
    });

    this._socket.on('nuevo-mensaje', (payload) {
      print(
        payload.containsKey('nombre') ? payload['nombre'] : 'no llego nada',
      );
    });
  }
}
