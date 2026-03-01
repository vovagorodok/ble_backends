import 'dart:async';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:ble_backend/ble_connector.dart';
import 'package:ble_backend/ble_mtu.dart';
import 'package:ble_backend/ble_characteristic.dart';
import 'package:ble_backend/base/base_ble_connector.dart';
import 'package:bluetooth_low_energy_backend/bluetooth_low_energy_mtu.dart';
import 'package:bluetooth_low_energy_backend/bluetooth_low_energy_characteristic.dart';

class BluetoothLowEnergyConnector extends BaseBleConnector {
  BluetoothLowEnergyConnector({
    required CentralManager backend,
    required Peripheral peripheral,
  })  : _backend = backend,
        _peripheral = peripheral {
    _backend.connectionStateChanged.listen(_updateState);
  }

  final CentralManager _backend;
  final Peripheral _peripheral;
  BleConnectorStatus _status = BleConnectorStatus.disconnected;
  List<GATTService>? _services;

  @override
  BleConnectorStatus get state => _status;

  @override
  Future<void> connect() async {
    await _backend.connect(_peripheral);
  }

  @override
  Future<void> disconnect() async {
    await _backend.disconnect(_peripheral);
  }

  @override
  Future<void> connectToKnownDevice(
      {Duration duration = const Duration(seconds: 2)}) async {
    throw UnsupportedError;
  }

  @override
  bool get isConnectToKnownDeviceSupported => false;

  @override
  String get deviceId => _peripheral.uuid.toString();

  @override
  Future<List<String>> discoverServices() async {
    return _services!.map((service) => service.uuid.toString()).toList();
  }

  @override
  BleMtu createMtu() {
    return BluetoothLowEnergyMtu(backend: _backend, peripheral: _peripheral);
  }

  @override
  BleCharacteristic createCharacteristic(
      {required String serviceId, required String characteristicId}) {
    return BluetoothLowEnergyCharacteristic(
        backend: _backend,
        connector: this,
        peripheral: _peripheral,
        serviceId: UUID.fromString(serviceId),
        characteristicId: UUID.fromString(characteristicId));
  }

  GATTCharacteristic? getCharacteristic(UUID serviceId, UUID characteristicId) {
    if (_status != BleConnectorStatus.connected) return null;
    final service = _services!.firstWhere((d) => d.uuid == serviceId);
    return service.characteristics
        .firstWhere((d) => d.uuid == characteristicId);
  }

  void _updateState(PeripheralConnectionStateChangedEventArgs update) {
    if (update.peripheral != _peripheral) return;

    if (update.state == ConnectionState.connected) {
      _backend.discoverGATT(_peripheral).then((services) {
        _services = services;
        _updateConnectorStatus(BleConnectorStatus.connected);
      });
    } else {
      _updateConnectorStatus(BleConnectorStatus.disconnected);
      _services = null;
    }
  }

  void _updateConnectorStatus(BleConnectorStatus status) {
    _status = status;
    notifyState(_status);
  }
}
