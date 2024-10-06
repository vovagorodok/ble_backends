import 'package:bluez/bluez.dart';
import 'package:ble_backend/ble_peripheral.dart';
import 'package:ble_backend/ble_connector.dart';
import 'package:bluez_backend/bluez_connector.dart';

class BlueZPeripheral extends BlePeripheral {
  BlueZPeripheral({required this.device, required this.serviceIds});

  final BlueZDevice device;
  final List<String> serviceIds;

  @override
  String get id => device.address;
  @override
  String? get name => device.alias;
  @override
  int? get rssi => device.rssi;

  @override
  BleConnector createConnector() {
    return BlueZConnector(
      device: device,
      serviceIds: serviceIds,
    );
  }
}
