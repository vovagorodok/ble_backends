import 'dart:async';

import 'package:universal_ble/universal_ble.dart' as backend;
import 'package:ble_backend/ble_connector.dart';
import 'package:ble_backend/ble_mtu.dart';
import 'package:ble_backend/ble_characteristic.dart';
import 'package:ble_backend/base/base_ble_connector.dart';
import 'package:universal_ble_backend/universal_ble_mtu.dart';
import 'package:universal_ble_backend/universal_ble_characteristic.dart';

class UniversalBleConnector extends BaseBleConnector {
  UniversalBleConnector({required String deviceId}) : _deviceId = deviceId {
    backend.UniversalBle.onConnectionChange =
        (String deviceId, bool isConnected, String? error) {
      if (deviceId != _deviceId) return;
      if (isConnected) return;
      _updateConnectorStatus(BleConnectorStatus.disconnected);
    };
  }

  final String _deviceId;
  BleConnectorStatus _state = BleConnectorStatus.disconnected;

  @override
  BleConnectorStatus get state => _state;

  @override
  Future<void> connect() async {
    try {
      await backend.UniversalBle.connect(_deviceId);
      await backend.UniversalBle.discoverServices(_deviceId);
      _updateConnectorStatus(BleConnectorStatus.connected);
    } catch (_) {}
  }

  @override
  Future<void> disconnect() async {
    await backend.UniversalBle.disconnect(_deviceId);
    _updateConnectorStatus(BleConnectorStatus.disconnected);
  }

  @override
  Future<void> connectToKnownDevice(
      {Duration duration = const Duration(seconds: 2)}) async {
    throw UnsupportedError;
  }

  @override
  String get deviceId => _deviceId;

  @override
  bool get isConnectToKnownDeviceSupported => false;

  @override
  Future<List<String>> discoverServices() async {
    return (await backend.UniversalBle.discoverServices(_deviceId))
        .map((service) => service.uuid)
        .toList();
  }

  @override
  BleMtu createMtu() {
    return UniversalBleMtu(deviceId: _deviceId);
  }

  @override
  BleCharacteristic createCharacteristic(
      {required String serviceId, required String characteristicId}) {
    return UniversalBleCharacteristic(
        deviceId: _deviceId,
        serviceId: serviceId,
        characteristicId: characteristicId);
  }

  void _updateConnectorStatus(BleConnectorStatus status) {
    if (_state == status) return;
    _state = status;
    notifyState(_state);
  }
}
