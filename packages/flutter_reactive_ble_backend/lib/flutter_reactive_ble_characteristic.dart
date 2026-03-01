import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:ble_backend/ble_characteristic.dart';

class FlutterReactiveBleCharacteristic extends BleCharacteristic {
  FlutterReactiveBleCharacteristic({
    required FlutterReactiveBle backend,
    required String deviceId,
    required Uuid serviceId,
    required Uuid characteristicId,
  })  : _backend = backend,
        _characteristic = QualifiedCharacteristic(
            characteristicId: characteristicId,
            serviceId: serviceId,
            deviceId: deviceId);

  final FlutterReactiveBle _backend;
  final QualifiedCharacteristic _characteristic;
  StreamSubscription? _subscription;

  @override
  Future<Uint8List> read() async {
    return Uint8List.fromList(
        await _backend.readCharacteristic(_characteristic));
  }

  @override
  Future<void> write({required Uint8List data}) async {
    await _backend.writeCharacteristicWithResponse(_characteristic,
        value: data);
  }

  @override
  Future<void> writeWithoutResponse({required Uint8List data}) async {
    await _backend.writeCharacteristicWithoutResponse(_characteristic,
        value: data);
  }

  @override
  Future<void> startNotifications() async {
    _subscription = _backend
        .subscribeToCharacteristic(_characteristic)
        .listen((data) => notifyData(Uint8List.fromList(data)));
  }

  @override
  Future<void> stopNotifications() async {
    await _subscription?.cancel();
  }
}
