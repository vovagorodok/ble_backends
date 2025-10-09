import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:bluez/bluez.dart';
import 'package:ble_backend/ble_central.dart';
import 'package:flutter_reactive_ble_backend/flutter_reactive_ble_central.dart';
import 'package:flutter_web_bluetooth_backend/flutter_web_bluetooth_central.dart';
import 'package:bluez_backend/bluez_central.dart';
import 'package:universal_ble_backend/universal_ble_central.dart';

BleCentral createCentral() {
  if (kIsWeb) {
    return FlutterWebBluetoothCentral();
  } else if (Platform.isAndroid || Platform.isIOS) {
    return FlutterReactiveBleCentral(backend: FlutterReactiveBle());
  } else if (Platform.isLinux) {
    return BlueZCentral(client: BlueZClient());
  } else {
    return UniversalBleCentral();
  }
}
