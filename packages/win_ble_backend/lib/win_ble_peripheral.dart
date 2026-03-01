import 'package:win_ble/win_ble.dart';
import 'package:ble_backend/ble_peripheral.dart';
import 'package:ble_backend/ble_connector.dart';
import 'package:win_ble_backend/win_ble_connector.dart';

class WinBlePeripheral extends BlePeripheral {
  WinBlePeripheral({required BleDevice device}) : _device = device;

  final BleDevice _device;

  @override
  String get id => _device.address;
  @override
  String? get name => _device.name;
  @override
  int? get rssi => int.tryParse(_device.rssi);

  @override
  BleConnector createConnector() {
    return WinBleConnector(deviceId: _device.address);
  }
}
