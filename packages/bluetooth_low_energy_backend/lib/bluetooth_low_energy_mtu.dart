import 'dart:async';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:ble_backend/ble_mtu.dart';

class BluetoothLowEnergyMtu extends BleMtu {
  BluetoothLowEnergyMtu({
    required CentralManager backend,
    required Peripheral peripheral,
  })  : _backend = backend,
        _peripheral = peripheral;

  final CentralManager _backend;
  final Peripheral _peripheral;

  @override
  Future<int> request({required int mtu}) async {
    return await _backend.requestMTU(_peripheral, mtu: mtu);
  }

  @override
  bool get isRequestSupported => true;
}
