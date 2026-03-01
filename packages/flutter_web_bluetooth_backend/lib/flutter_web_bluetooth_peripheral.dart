import "package:flutter_web_bluetooth/flutter_web_bluetooth.dart";
import 'package:ble_backend/ble_peripheral.dart';
import 'package:ble_backend/ble_connector.dart';
import 'package:flutter_web_bluetooth_backend/flutter_web_bluetooth_connector.dart';

class FlutterWebBluetoothPeripheral extends BlePeripheral {
  FlutterWebBluetoothPeripheral({required BluetoothDevice device})
      : _device = device;

  final BluetoothDevice _device;

  @override
  String get id => _device.id;
  @override
  String? get name => _device.name;
  @override
  int? get rssi => null;

  @override
  BleConnector createConnector() {
    return FlutterWebBluetoothConnector(device: _device);
  }
}
