import 'dart:async';

import 'package:bluez/bluez.dart';
import 'package:ble_backend/ble_connector.dart';
import 'package:ble_backend/ble_mtu.dart';
import 'package:ble_backend/ble_characteristic.dart';
import 'package:ble_backend/base/base_ble_connector.dart';
import 'package:bluez_backend/bluez_mtu.dart';
import 'package:bluez_backend/bluez_characteristic.dart';

class BlueZConnector extends BaseBleConnector {
  BlueZConnector({
    required BlueZDevice device,
  }) : _device = device;

  final BlueZDevice _device;
  BleConnectorStatus _state = BleConnectorStatus.disconnected;

  @override
  BleConnectorStatus get state => _state;

  @override
  Future<void> connect() async {
    await _device.connect();

    int attempts = 0;
    do {
      await Future.delayed(const Duration(milliseconds: 100));
      attempts++;
    } while (attempts < 10 && !_device.connected);

    _updateConnectorStatus(_device.connected
        ? BleConnectorStatus.connected
        : BleConnectorStatus.disconnected);
  }

  @override
  Future<void> disconnect() async {
    await _device.disconnect();
    _updateConnectorStatus(BleConnectorStatus.disconnected);
  }

  @override
  Future<void> connectToKnownDevice(
      {Duration duration = const Duration(seconds: 2)}) async {
    throw UnsupportedError;
  }

  @override
  bool get isConnectToKnownDeviceSupported => false;

  @override
  String get deviceId => _device.address;

  @override
  Future<List<String>> discoverServices() async {
    return _device.gattServices
        .map((service) => service.uuid.toString())
        .toList();
  }

  @override
  BleMtu createMtu() {
    return BlueZMtu(device: _device);
  }

  @override
  BleCharacteristic createCharacteristic(
      {required String serviceId, required String characteristicId}) {
    return BlueZCharacteristic(
        device: _device,
        serviceId: BlueZUUID.fromString(serviceId),
        characteristicId: BlueZUUID.fromString(characteristicId));
  }

  void _updateConnectorStatus(BleConnectorStatus status) {
    _state = status;
    notifyState(_state);
  }
}
