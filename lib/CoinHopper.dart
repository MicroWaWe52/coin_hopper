import 'dart:ffi';
import 'dart:typed_data';

import 'package:usb_serial/usb_serial.dart';

class CoinHopper {
  late UsbPort port;
  CoinHopper(UsbPort p) {
    port = p;
  }

  Future<Iterable<int>> getSerial(int address) async {
    var data = [address, 00, 01, 0xf2];
    var dataSerial = Uint8List.fromList(data);

    port!.open();

    await port!.setDTR(true);
    await port!.setRTS(true);

    port!.setPortParameters(
        9600, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);
    dataSerial.add(CalculateCrc(dataSerial));
    await port!.write(dataSerial);

    var res = await port!.inputStream!.first;
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
