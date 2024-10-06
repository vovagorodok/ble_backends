import 'dart:async';

import 'package:ble_backend/state_notifier.dart';
import 'package:ble_backend/ble_mtu.dart';
import 'package:ble_backend/ble_characteristic.dart';
import 'package:ble_backend/ble_serial.dart';

abstract class BleConnector extends StatefulNotifier<BleConnectorStatus> {
  Future<void> connect();
  Future<void> disconnect();
  Future<void> connectToKnownDevice({Duration duration});
  bool get isConnectToKnownDeviceSupported;

  Future<List<String>> discoverServices();

  BleMtu createMtu();
  BleCharacteristic createCharacteristic(
      {required String serviceId, required String characteristicId});
  BleSerial createSerial(
      {required String serviceId,
      required String rxCharacteristicId,
      required String txCharacteristicId});
}

enum BleConnectorStatus {
  connecting,
  connected,
  disconnecting,
  disconnected,
  scanning,
}
