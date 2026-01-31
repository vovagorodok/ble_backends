import 'dart:async';
import 'dart:typed_data';

import 'package:universal_ble/universal_ble.dart' as backend;
import 'package:ble_backend/ble_characteristic.dart';

class UniversalBleCharacteristic extends BleCharacteristic {
  UniversalBleCharacteristic({
    required this.deviceId,
    required this.serviceId,
    required this.characteristicId,
  });

  final String deviceId;
  final String serviceId;
  final String characteristicId;

  @override
  Future<Uint8List> read() async {
    return await backend.UniversalBle.read(
        deviceId, serviceId, characteristicId);
  }

  @override
  Future<void> write({required Uint8List data}) async {
    await backend.UniversalBle.write(
        deviceId, serviceId, characteristicId, data,
        withoutResponse: false);
  }

  @override
  Future<void> writeWithoutResponse({required Uint8List data}) async {
    await backend.UniversalBle.write(
        deviceId, serviceId, characteristicId, data,
        withoutResponse: true);
  }

  @override
  Future<void> startNotifications() async {
    backend.UniversalBle.onValueChange = (String deviceId,
        String characteristicId, Uint8List value, int? timestamp) {
      if (characteristicId == this.characteristicId) {
        notifyData(value);
      }
    };
    backend.UniversalBle.subscribeNotifications(
        deviceId, serviceId, characteristicId);
  }

  @override
  Future<void> stopNotifications() async {
    backend.UniversalBle.unsubscribe(deviceId, serviceId, characteristicId);
    backend.UniversalBle.onValueChange = null;
  }
}
