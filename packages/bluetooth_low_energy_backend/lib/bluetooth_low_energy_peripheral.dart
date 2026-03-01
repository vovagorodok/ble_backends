import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:ble_backend/ble_peripheral.dart';
import 'package:ble_backend/ble_connector.dart';
import 'package:bluetooth_low_energy_backend/bluetooth_low_energy_connector.dart';

class BluetoothLowEnergyPeripheral extends BlePeripheral {
  BluetoothLowEnergyPeripheral({
    required CentralManager backend,
    required DiscoveredEventArgs device,
  })  : _backend = backend,
        _device = device;

  final CentralManager _backend;
  final DiscoveredEventArgs _device;

  @override
  String get id => _device.peripheral.uuid.toString();
  @override
  String? get name => _device.advertisement.name;
  @override
  int? get rssi => _device.rssi;

  @override
  BleConnector createConnector() {
    return BluetoothLowEnergyConnector(
      backend: _backend,
      peripheral: _device.peripheral,
    );
  }
}
