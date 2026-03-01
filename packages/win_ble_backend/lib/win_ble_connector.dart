import 'dart:async';

import 'package:win_ble/win_ble.dart' as backend;
import 'package:ble_backend/ble_connector.dart';
import 'package:ble_backend/ble_mtu.dart';
import 'package:ble_backend/ble_characteristic.dart';
import 'package:ble_backend/base/base_ble_connector.dart';
import 'package:win_ble_backend/win_ble_mtu.dart';
import 'package:win_ble_backend/win_ble_characteristic.dart';

class WinBleConnector extends BaseBleConnector {
  WinBleConnector({required String deviceId}) : _deviceId = deviceId {
    backend.WinBle.connectionStreamOf(_deviceId).listen((isConnected) {
      _updateConnectorStatus(isConnected
          ? BleConnectorStatus.connected
          : BleConnectorStatus.disconnected);
    });
  }

  final String _deviceId;
  BleConnectorStatus _state = BleConnectorStatus.disconnected;

  @override
  BleConnectorStatus get state => _state;

  @override
  Future<void> connect() async {
    await backend.WinBle.connect(_deviceId);
  }

  @override
  Future<void> disconnect() async {
    await backend.WinBle.disconnect(_deviceId);
  }

  @override
  Future<void> connectToKnownDevice(
      {Duration duration = const Duration(seconds: 2)}) async {
    throw UnsupportedError;
  }

  @override
  bool get isConnectToKnownDeviceSupported => false;

  @override
  String get deviceId => _deviceId;

  @override
  Future<List<String>> discoverServices() async {
    return await backend.WinBle.discoverServices(_deviceId);
  }

  @override
  BleMtu createMtu() {
    return WinBleMtu(deviceId: _deviceId);
  }

  @override
  BleCharacteristic createCharacteristic(
      {required String serviceId, required String characteristicId}) {
    return WinBleCharacteristic(
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
