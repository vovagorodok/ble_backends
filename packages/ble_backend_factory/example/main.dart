import 'package:ble_backend/ble_central.dart';
import 'package:ble_backend/ble_connector.dart';
import 'package:ble_backend/utils/converters.dart';
import 'package:ble_backend_factory/ble_central.dart';

const serviceId = "dac890c2-35a1-11ef-aba0-9b95565f4ffb";
const rxCharacteristicId = "dac89194-35a1-11ef-aba1-b37714ad9a54";
const txCharacteristicId = "dac89266-35a1-11ef-aba2-0f0127bce478";
const characteristicId = "dac89338-35a1-11ef-aba3-8746a2fdea8c";

Future<void> wait(bool Function() predicate) async {
  for (int i = 0; i < 10; i++) {
    await Future.delayed(const Duration(milliseconds: 100));
    if (predicate()) return;
  }
}

void main() async {
  // Central
  print("Cantral state: ${bleCentral.state}");
  bleCentral.stateStream
      .listen((state) => print("Cantral state changed: $state"));

  await wait(() => bleCentral.state != BleCentralStatus.unknown);
  if (bleCentral.state != BleCentralStatus.ready) {
    print("Bluetooth not ready");
    return;
  }

  // Scanner
  final bleScanner = bleCentral.createScanner(serviceIds: [serviceId]);
  bleScanner.stateStream
      .listen((state) => print("Scaning: ${state.isScanInProgress}"));
  await bleScanner.scan();
  await Future.delayed(const Duration(seconds: 1));
  await bleScanner.stop();

  if (bleScanner.state.devices.isEmpty) {
    print("Device not found");
    return;
  }

  // Peripheral
  final blePeripheral = bleScanner.state.devices.first;
  print("Peripheral id: ${blePeripheral.id}");
  print("Peripheral name: ${blePeripheral.name}");
  print("Peripheral rssi: ${blePeripheral.rssi}");

  // Connector
  final bleConnector = blePeripheral.createConnector();
  print("Connector state: ${bleConnector.state}");
  bleConnector.stateStream
      .listen((state) => print("Connector state changed: $state"));
  await bleConnector.connect();

  await wait(() => bleConnector.state == BleConnectorStatus.connected);
  if (bleConnector.state != BleConnectorStatus.connected) {
    print("Device not connected");
    return;
  }

  // Mtu
  final bleMtu = bleConnector.createMtu();
  if (bleMtu.isRequestSupported) {
    print("Mtu requested: ${await bleMtu.request(mtu: 128)}");
  }

  // Characteristic
  final bleCharacteristic = bleConnector.createCharacteristic(
      serviceId: serviceId, characteristicId: characteristicId);
  bleCharacteristic.dataStream
      .listen((data) => print("Characteristic data changed: $data"));
  await bleCharacteristic.startNotifications();
  print("Characteristic data: ${await bleCharacteristic.read()}");
  await bleCharacteristic.write(data: uint8ToBytes(1));
  await bleCharacteristic.writeWithoutResponse(data: uint8ToBytes(2));
  await bleCharacteristic.stopNotifications();

  // Serial
  final bleSerial = bleConnector.createSerial(
      serviceId: serviceId,
      rxCharacteristicId: rxCharacteristicId,
      txCharacteristicId: txCharacteristicId);
  bleSerial.dataStream.listen((data) => print("Serial data received: $data"));
  await bleSerial.startNotifications();
  await bleSerial.send(data: uint8ToBytes(3));
  bleSerial.waitData(timeoutCallback: () => print("Serial data not received"));
  await Future.delayed(const Duration(milliseconds: 100));
  await bleSerial.stopNotifications();

  await bleConnector.disconnect();
}
