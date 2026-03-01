import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:ble_backend/ble_scanner.dart';
import 'package:ble_backend/ble_peripheral.dart';
import 'package:ble_backend/base/base_ble_scanner.dart';
import 'package:flutter_reactive_ble_backend/flutter_reactive_ble_peripheral.dart';

class FlutterReactiveBleScanner extends BaseBleScanner {
  FlutterReactiveBleScanner({
    required FlutterReactiveBle backend,
    required List<Uuid> serviceIds,
  })  : _backend = backend,
        _serviceIds = serviceIds;

  final FlutterReactiveBle _backend;
  final List<Uuid> _serviceIds;
  StreamSubscription? _subscription;

  @override
  BleScannerState get state => BleScannerState(
        devices: devices,
        isScanInProgress: _subscription != null,
      );

  @override
  Future<void> scan() async {
    devices.clear();
    await _subscription?.cancel();
    _subscription = _backend.scanForDevices(withServices: _serviceIds).listen(
        (device) => addPeripheral(_createPeripheral(device)),
        onError: (Object e) {});
    notifyState(state);
  }

  @override
  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
    notifyState(state);
  }

  BlePeripheral _createPeripheral(DiscoveredDevice device) {
    return FlutterReactiveBlePeripheral(
      backend: _backend,
      serviceIds: _serviceIds,
      discoveredDevice: device,
    );
  }
}
