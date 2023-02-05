import 'dart:typed_data';
import 'package:http/http.dart' as http;

class CoinHopper {
  String baseEndpoint = "http://localhost:5555/";
  void messageReceived(String msg) {}

  //starting the connection and listening to the socket asynchronously

  Future poll() async {
    http.get(Uri.parse(baseEndpoint + "poll"));
  }

  Future dispense() async {
    http.post(Uri.parse(baseEndpoint + "coins/5"));
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
