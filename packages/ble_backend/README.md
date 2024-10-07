# BLE backend

BLE backend interfaces

## Usage

Cantral:
```dart
final bleCentral = createCentral();
print("Cantral state: ${bleCentral.state}");
bleCentral.stateStream.listen((state) => print("Cantral state changed: $state"));
```

Scanner:
```dart
final bleScanner = bleCentral.createScanner(serviceIds: [serviceId]);
bleScanner.stateStream.listen((state) => print("Scaning: ${state.isScanInProgress}"));
await bleScanner.scan();
await Future.delayed(const Duration(seconds: 1));
await bleScanner.stop();
```

Peripheral:
```dart
final blePeripheral = bleScanner.state.devices.first;
print("Peripheral id: ${blePeripheral.id}");
print("Peripheral name: ${blePeripheral.name}");
print("Peripheral rssi: ${blePeripheral.rssi}");
```

Connector:
```dart
final bleConnector = blePeripheral.createConnector();
print("Connector state: ${bleConnector.state}");
bleConnector.stateStream.listen((state) => print("Connector state changed: $state"));
await bleConnector.connect();
```

Mtu:
```dart
final bleMtu = bleConnector.createMtu();
if (bleMtu.isRequestSupported) print("Mtu requested: ${await bleMtu.request(mtu: 128)}");
```

Characteristic:
```dart
final bleCharacteristic = bleConnector.createCharacteristic(serviceId: serviceId, characteristicId: characteristicId);
bleCharacteristic.dataStream.listen((data) => print("Characteristic data changed: $data"));
await bleCharacteristic.startNotifications();
print("Characteristic data: ${await bleCharacteristic.read()}");
await bleCharacteristic.write(data: data);
await bleCharacteristic.writeWithoutResponse(data: data);
await bleCharacteristic.stopNotifications();
```

Serial:
```dart
final bleSerial = bleConnector.createSerial(
    serviceId: serviceId,
    rxCharacteristicId: rxCharacteristicId,
    txCharacteristicId: txCharacteristicId);
bleSerial.dataStream.listen((data) => print("Serial data received: $data"));
await bleSerial.startNotifications();
await bleSerial.send(data: data);
bleSerial.waitData(timeoutCallback: () => print("Serial data not received"));
await bleSerial.stopNotifications();
```