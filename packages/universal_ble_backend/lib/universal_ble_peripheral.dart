import 'package:universal_ble/universal_ble.dart';
import 'package:ble_backend/ble_peripheral.dart';
import 'package:ble_backend/ble_connector.dart';
import 'package:universal_ble_backend/universal_ble_connector.dart';

class UniversalBlePeripheral extends BlePeripheral {
  UniversalBlePeripheral({required BleDevice device}) : _device = device;

  final BleDevice _device;

  @override
  String get id => _device.deviceId;
  @override
  String? get name => _device.name;
  @override
  int? get rssi => _device.rssi;

  @override
  BleConnector createConnector() {
    return UniversalBleConnector(deviceId: _device.deviceId);
  }
}
