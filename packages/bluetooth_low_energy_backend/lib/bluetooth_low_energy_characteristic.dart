import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:ble_backend/ble_characteristic.dart';
import 'package:bluetooth_low_energy_backend/bluetooth_low_energy_connector.dart';

class BluetoothLowEnergyCharacteristic extends BleCharacteristic {
  BluetoothLowEnergyCharacteristic({
    required CentralManager backend,
    required BluetoothLowEnergyConnector connector,
    required Peripheral peripheral,
    required UUID serviceId,
    required UUID characteristicId,
  })  : _backend = backend,
        _connector = connector,
        _peripheral = peripheral,
        _serviceId = serviceId,
        _characteristicId = characteristicId;

  final CentralManager _backend;
  final BluetoothLowEnergyConnector _connector;
  final Peripheral _peripheral;
  final UUID _serviceId;
  final UUID _characteristicId;
  StreamSubscription? _subscription;

  @override
  Future<Uint8List> read() async {
    final characteristic = _getCharacteristic();
    return await _backend.readCharacteristic(_peripheral, characteristic!);
  }

  @override
  Future<void> write({required Uint8List data}) async {
    final characteristic = _getCharacteristic();
    await _backend.writeCharacteristic(_peripheral, characteristic!,
        value: data, type: GATTCharacteristicWriteType.withResponse);
  }

  @override
  Future<void> writeWithoutResponse({required Uint8List data}) async {
    final characteristic = _getCharacteristic();
    await _backend.writeCharacteristic(_peripheral, characteristic!,
        value: data, type: GATTCharacteristicWriteType.withoutResponse);
  }

  @override
  Future<void> startNotifications() async {
    final characteristic = _getCharacteristic();
    _subscription = _backend.characteristicNotified.listen((data) {
      if (data.peripheral.uuid != _peripheral.uuid ||
          data.characteristic.uuid != _characteristicId) return;
      notifyData(data.value);
    });
    await _backend.setCharacteristicNotifyState(_peripheral, characteristic!,
        state: true);
  }

  @override
  Future<void> stopNotifications() async {
    final characteristic = _getCharacteristic();
    await _backend.setCharacteristicNotifyState(_peripheral, characteristic!,
        state: false);
    await _subscription?.cancel();
  }

  GATTCharacteristic? _getCharacteristic() {
    return _connector.getCharacteristic(_serviceId, _characteristicId);
  }
}
