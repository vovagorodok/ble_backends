import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:bluez/bluez.dart';
import 'package:ble_backend/ble_central.dart';
import 'package:flutter_reactive_ble_backend/flutter_reactive_ble_central.dart';
import 'package:flutter_web_bluetooth_backend/flutter_web_bluetooth_central.dart';
import 'package:bluez_backend/bluez_central.dart';
import 'package:win_ble_backend/win_ble_central.dart';
import 'package:bluetooth_low_energy_backend/bluetooth_low_energy_central.dart';

BleCentral createCentral() {
  if (kIsWeb) {
    return FlutterWebBluetoothCentral();
  } else if (Platform.isAndroid || Platform.isIOS) {
    return FlutterReactiveBleCentral(backend: FlutterReactiveBle());
  } else if (Platform.isLinux) {
    return BlueZCentral(client: BlueZClient());
  } else if (Platform.isWindows) {
    return WinBleCentral();
  } else {
    return BluetoothLowEnergyCentral(backend: CentralManager());
  }
}
