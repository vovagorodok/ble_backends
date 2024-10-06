import 'package:win_ble/win_ble.dart';
import 'package:ble_backend/ble_peripheral.dart';
import 'package:ble_backend/ble_connector.dart';
import 'package:win_ble_backend/win_ble_connector.dart';

class WinBlePeripheral extends BlePeripheral {
  WinBlePeripheral({required this.device, required this.serviceIds});

  final BleDevice device;
  final List<String> serviceIds;

  @override
  String get id => device.address;
  @override
  String? get name => device.name;
  @override
  int? get rssi => int.tryParse(device.rssi);

  @override
  BleConnector createConnector() {
    return WinBleConnector(
      deviceId: device.address,
      serviceIds: serviceIds,
    );
  }
}
