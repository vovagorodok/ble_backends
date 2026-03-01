import 'dart:async';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:ble_backend/ble_scanner.dart';
import 'package:ble_backend/ble_peripheral.dart';
import 'package:ble_backend/base/base_ble_scanner.dart';
import 'package:bluetooth_low_energy_backend/bluetooth_low_energy_peripheral.dart';

class BluetoothLowEnergyScanner extends BaseBleScanner {
  BluetoothLowEnergyScanner({
    required CentralManager backend,
    required List<UUID> serviceIds,
  })  : _backend = backend,
        _serviceIds = serviceIds {
    _backend.discovered
        .listen((device) => addPeripheral(_createPeripheral(device)));
  }

  final CentralManager _backend;
  final List<UUID> _serviceIds;
  bool _isScanInProgress = false;

  @override
  BleScannerState get state => BleScannerState(
        devices: devices,
        isScanInProgress: _isScanInProgress,
      );

  @override
  Future<void> scan() async {
    devices.clear();
    _isScanInProgress = true;
    await _backend.startDiscovery(serviceUUIDs: _serviceIds);
    notifyState(state);
  }

  @override
  Future<void> stop() async {
    if (!_isScanInProgress) return;
    _isScanInProgress = false;
    await _backend.stopDiscovery();
    notifyState(state);
  }

  BlePeripheral _createPeripheral(DiscoveredEventArgs device) {
    return BluetoothLowEnergyPeripheral(
      backend: _backend,
      device: device,
    );
  }
}
