import 'package:bluez/bluez.dart';
import 'package:ble_backend/ble_peripheral.dart';
import 'package:ble_backend/ble_connector.dart';
import 'package:bluez_backend/bluez_connector.dart';

class BlueZPeripheral extends BlePeripheral {
  BlueZPeripheral({required BlueZDevice device}) : _device = device;

  final BlueZDevice _device;

  @override
  String get id => _device.address;
  @override
  String? get name => _device.alias;
  @override
  int? get rssi => _device.rssi;

  @override
  BleConnector createConnector() {
    return BlueZConnector(device: _device);
  }
}
