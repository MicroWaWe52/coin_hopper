import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter_libserialport/flutter_libserialport.dart';

class CoinHopper {
  late SerialPort device;
  CoinHopper(String portCode) {
    device = SerialPort(portCode);
  }

  Future<Iterable<int>> getSerial(int address) async {
    var data = [address, 00, 01, 0xf2];
    var dataSerial = Uint8List.fromList(data);
    device.openReadWrite();

    device.config.baudRate = 9600;
    device.config.parity = 0;
    device.config.stopBits = 1;
    device.config.bits = 8;

    dataSerial.add(CalculateCrc(dataSerial));
    device.write(dataSerial);

    var res = await device.read(8);
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
