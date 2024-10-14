# BLE backend screens

BLE `status` and `scanner` screens that halps to create examples with `ble_backend` library

## Usage
Just implement `PeripheralScreen` and use as follows:
```dart
ScannerScreen(
    bleCentral: bleCentral,
    bleScanner: bleCentral.createScanner(serviceIds: serviceIds),
    createStatusScreen: (bleCentral) =>
        StatusScreen(bleCentral: bleCentral),
    createPeripheralScreen: (blePeripheral) =>
        PeripheralScreen(blePeripheral: blePeripheral))
```