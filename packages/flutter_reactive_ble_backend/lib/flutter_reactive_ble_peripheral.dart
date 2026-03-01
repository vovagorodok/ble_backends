import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:ble_backend/ble_peripheral.dart';
import 'package:ble_backend/ble_connector.dart';
import 'package:flutter_reactive_ble_backend/flutter_reactive_ble_connector.dart';

class FlutterReactiveBlePeripheral extends BlePeripheral {
  FlutterReactiveBlePeripheral({
    required FlutterReactiveBle backend,
    required List<Uuid> serviceIds,
    required DiscoveredDevice discoveredDevice,
  })  : _backend = backend,
        _serviceIds = serviceIds,
        _discoveredDevice = discoveredDevice;

  final FlutterReactiveBle _backend;
  final List<Uuid> _serviceIds;
  final DiscoveredDevice _discoveredDevice;

  @override
  String get id => _discoveredDevice.id;
  @override
  String? get name => _discoveredDevice.name;
  @override
  int? get rssi => _discoveredDevice.rssi;

  @override
  BleConnector createConnector() {
    return FlutterReactiveBleConnector(
        backend: _backend, deviceId: id, serviceIds: _serviceIds);
  }
}
