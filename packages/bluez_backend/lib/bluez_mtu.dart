import 'dart:async';
import 'dart:math';

import 'package:bluez/bluez.dart';
import 'package:ble_backend/ble_mtu.dart';

class BlueZMtu extends BleMtu {
  BlueZMtu({required this.device});
  final BlueZDevice device;

  @override
  Future<int> request({required int mtu}) async {
    for (BlueZGattService service in device.gattServices) {
      for (BlueZGattCharacteristic characteristic in service.characteristics) {
        int? requested = characteristic.mtu;
        // The value provided by Bluez includes an extra 3 bytes from the GATT header, which needs to be removed.
        if (requested != null) return min(requested - 3, mtu);
      }
    }
    return min(23, mtu);
  }

  @override
  bool get isRequestSupported => true;
}
