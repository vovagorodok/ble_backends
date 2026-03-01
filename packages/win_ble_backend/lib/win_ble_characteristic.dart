import 'dart:async';
import 'dart:typed_data';

import 'package:win_ble/win_ble.dart' as backend;
import 'package:ble_backend/ble_characteristic.dart';

class WinBleCharacteristic extends BleCharacteristic {
  WinBleCharacteristic({
    required String deviceId,
    required String serviceId,
    required String characteristicId,
  })  : _deviceId = deviceId,
        _serviceId = serviceId,
        _characteristicId = characteristicId {
    backend.WinBle.characteristicValueStreamOf(
            address: _deviceId,
            serviceId: _serviceId,
            characteristicId: _characteristicId)
        .listen((value) {
      notifyData(Uint8List.fromList(value));
    });
  }

  final String _deviceId;
  final String _serviceId;
  final String _characteristicId;

  @override
  Future<Uint8List> read() async {
    return Uint8List.fromList(await backend.WinBle.read(
        address: _deviceId,
        serviceId: _serviceId,
        characteristicId: _characteristicId));
  }

  @override
  Future<void> write({required Uint8List data}) async {
    await backend.WinBle.write(
        address: _deviceId,
        service: _serviceId,
        characteristic: _characteristicId,
        data: data,
        writeWithResponse: true);
  }

  @override
  Future<void> writeWithoutResponse({required Uint8List data}) async {
    await backend.WinBle.write(
        address: _deviceId,
        service: _serviceId,
        characteristic: _characteristicId,
        data: data,
        writeWithResponse: false);
  }

  @override
  Future<void> startNotifications() async {
    await backend.WinBle.subscribeToCharacteristic(
        address: _deviceId,
        serviceId: _serviceId,
        characteristicId: _characteristicId);
  }

  @override
  Future<void> stopNotifications() async {
    await backend.WinBle.unSubscribeFromCharacteristic(
        address: _deviceId,
        serviceId: _serviceId,
        characteristicId: _characteristicId);
  }
}
