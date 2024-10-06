import 'dart:async';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:ble_backend/ble_mtu.dart';

class BluetoothLowEnergyMtu extends BleMtu {
  BluetoothLowEnergyMtu({required this.backend, required this.peripheral});

  final CentralManager backend;
  final Peripheral peripheral;

  @override
  Future<int> request({required int mtu}) async {
    return await backend.requestMTU(peripheral, mtu: mtu);
  }

  @override
  bool get isRequestSupported => true;
}
