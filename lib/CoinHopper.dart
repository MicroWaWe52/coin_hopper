import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:tcp_socket_connection/tcp_socket_connection.dart';

class CoinHopper {
  TcpSocketConnection socketConnection = TcpSocketConnection("127.0.0.1", 4444);
  CoinHopper(String portCode) {
    startConnection();
  }

  void messageReceived(String msg) {
    socketConnection.sendMessage("MessageIsReceived :D ");
  }

  //starting the connection and listening to the socket asynchronously
  Future startConnection() async {
    socketConnection.enableConsolePrint(
        true); //use this to see in the console what's happening
    if (await socketConnection.canConnect(5000, attempts: 3)) {
      //check if it's possible to connect to the endpoint
      await socketConnection.connect(5000, messageReceived, attempts: 3);
      socketConnection.sendMessage("Connected");
    }
  }

  Future<Iterable<int>> getSerial(int address) async {
    var data = [address, 00, 01, 0xf2];
    var dataSerial = Uint8List.fromList(data);
    if (!socketConnection.isConnected()) {
      await startConnection();
    }
    data.add(CalculateCrc(data));

    socketConnection.sendMessage("message");
    return data;
  }

  CalculateCrc(List<int> buffer) {
    var sum = 0;

    for (var element in buffer) {
      sum += element;
    }

    // NOTE not 0xFF but 0x100
    return 0x100 - sum % 0x100;
  }
}
