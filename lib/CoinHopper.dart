import 'dart:ffi';
import 'dart:typed_data';

import 'package:usb_serial/usb_serial.dart';

class CoinHopper {
  late UsbDevice device;
  CoinHopper(UsbDevice portCode) {
    device = portCode;
  }

  Future<Iterable<int>> getSerial(int address) async {
    var data = [address, 00, 01, 0xf2];
    var dataSerial = Uint8List.fromList(data);
    device.port!.open();

    await device.port!.setDTR(true);
    await device.port!.setRTS(true);

    device.port!.setPortParameters(
        9600, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);
    dataSerial.add(CalculateCrc(dataSerial));
    await device.port!.write(dataSerial);

    var res = await device.port!.inputStream!.first;
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
