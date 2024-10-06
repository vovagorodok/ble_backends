import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:ble_backend/base_ble_scanner.dart';
import 'package:ble_backend/ble_scanner.dart';
import 'package:ble_backend/ble_peripheral.dart';
import 'package:flutter_reactive_ble_backend/flutter_reactive_ble_peripheral.dart';

class FlutterReactiveBleScanner extends BaseBleScanner {
  FlutterReactiveBleScanner({required this.backend, required this.serviceIds});

  final FlutterReactiveBle backend;
  final List<Uuid> serviceIds;
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
    _subscription = backend.scanForDevices(withServices: serviceIds).listen(
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
      backend: backend,
      serviceIds: serviceIds,
      discoveredDevice: device,
    );
  }
}
