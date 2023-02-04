import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter_libserialport/flutter_libserialport.dart';

class CoinHopper {
  late SerialPort device;
  CoinHopper(String portCode) {
    device = SerialPort(portCode);

    device.openReadWrite();
    Future.delayed(const Duration(seconds: 2), () {
      device.config.baudRate = 9600;
      device.config.parity = 0;
      device.config.stopBits = 1;
      device.config.bits = 8;
    });

    final reader = SerialPortReader(device, timeout: 1000);
    reader.stream.listen((data) {
      print('received: $data');
    });
  }

  Future<Iterable<int>> getSerial(int address) async {
    var data = [address, 00, 01, 0xfe];

    data.add(CalculateCrc(data));
    var dataSerial = Uint8List.fromList(data);

    device.write(dataSerial, timeout: 100);
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
