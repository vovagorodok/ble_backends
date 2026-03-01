import 'dart:async';

import 'package:bluez/bluez.dart';
import 'package:ble_backend/ble_scanner.dart';
import 'package:ble_backend/ble_peripheral.dart';
import 'package:ble_backend/base/base_ble_scanner.dart';
import 'package:bluez_backend/bluez_peripheral.dart';

class BlueZScanner extends BaseBleScanner {
  BlueZScanner({
    required BlueZClient client,
    required List<String> serviceIds,
  })  : _client = client,
        _serviceIds = serviceIds {
    _client.deviceAdded
        .listen((device) => addPeripheral(_createPeripheral(device)));
  }

  final BlueZClient _client;
  final List<String> _serviceIds;
  bool _isScanInProgress = false;

  @override
  BleScannerState get state => BleScannerState(
        devices: devices,
        isScanInProgress: _isScanInProgress,
      );

  @override
  Future<void> scan() async {
    await _client.adapters.first.setDiscoveryFilter(uuids: _serviceIds);
    await _client.adapters.first.startDiscovery();
    _isScanInProgress = true;
    notifyState(state);
  }

  @override
  Future<void> stop() async {
    if (!_isScanInProgress) return;
    await _client.adapters.first.stopDiscovery();
    _isScanInProgress = false;
    notifyState(state);
  }

  BlePeripheral _createPeripheral(BlueZDevice device) {
    return BlueZPeripheral(device: device);
  }
}
