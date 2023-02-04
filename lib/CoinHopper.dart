import 'dart:typed_data';

import 'package:linux_serial/linux_serial.dart';

class CoinHopper {
  late SerialPortHandle port;
  CoinHopper(SerialPortHandle p) {
    port = p;
  }

  Future<Iterable<int>> getSerial(int address) async {
    var data = [address, 00, 01, 0xf2];
    var dataSerial = Uint8List.fromList(data);

    dataSerial.add(CalculateCrc(dataSerial));
    await port.write(dataSerial);

    var res = await port.readBytes(8);
    return res.getRange(4, 7);
  }

  CalculateCrc(Uint8List buffer) {
    var sum = 0;

    for (var element in buffer) {
      sum += element;
    }

    // NOTE not 0xFF but 0x100
    return 0x100 - sum % 0x100;
  }
}
