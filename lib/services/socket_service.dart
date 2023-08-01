import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { 
  Online, 
  Offline, 
  Connecting
}

class SocketService with ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;


  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    //Dart client
    _socket = IO.io('http://localhost:3000/', {
      'transports': ['websocket'],
      'autoConnect': true
    });

    _socket.on('connect', (_) {
      print('connected');
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    _socket.on('disconnect', (_) {
      print('disconnected');
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
    
    _socket.on('sendMessage', (payload) {
      print('newMessage: $payload');
      //notifyListeners();
    });

  }

}