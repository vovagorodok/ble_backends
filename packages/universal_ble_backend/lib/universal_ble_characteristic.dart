import 'dart:async';
import 'dart:typed_data';

import 'package:universal_ble/universal_ble.dart' as backend;
import 'package:ble_backend/ble_characteristic.dart';

class UniversalBleCharacteristic extends BleCharacteristic {
  UniversalBleCharacteristic({
    required String deviceId,
    required String serviceId,
    required String characteristicId,
  })  : _deviceId = deviceId,
        _serviceId = serviceId,
        _characteristicId = characteristicId;

  final String _deviceId;
  final String _serviceId;
  final String _characteristicId;

  @override
  Future<Uint8List> read() async {
    return await backend.UniversalBle.read(
        _deviceId, _serviceId, _characteristicId);
  }

  @override
  Future<void> write({required Uint8List data}) async {
    await backend.UniversalBle.write(
        _deviceId, _serviceId, _characteristicId, data,
        withoutResponse: false);
  }

  @override
  Future<void> writeWithoutResponse({required Uint8List data}) async {
    await backend.UniversalBle.write(
        _deviceId, _serviceId, _characteristicId, data,
        withoutResponse: true);
  }

  @override
  Future<void> startNotifications() async {
    backend.UniversalBle.onValueChange = (String deviceId,
        String characteristicId, Uint8List value, int? timestamp) {
      if (characteristicId == _characteristicId) {
        notifyData(value);
      }
    };
    backend.UniversalBle.subscribeNotifications(
        _deviceId, _serviceId, _characteristicId);
  }

  @override
  Future<void> stopNotifications() async {
    backend.UniversalBle.unsubscribe(_deviceId, _serviceId, _characteristicId);
    backend.UniversalBle.onValueChange = null;
  }
}
