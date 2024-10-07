# BLE Backend

BLE backend interfaces

## Usage

Cantral:
```dart
print("Cantral state: ${bleCentral.state}");
bleCentral.stateStream.listen(() => print("Cantral state changed: ${bleCentral.state}"));
```

Scanner:
```dart
final bleScanner = bleCentral.createScanner(serviceIds: [serviceUuid]);
```