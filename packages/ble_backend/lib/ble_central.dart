import 'package:ble_backend/state_notifier.dart';
import 'package:ble_backend/ble_scanner.dart';
import 'package:ble_backend/ble_connector.dart';

abstract class BleCentral extends StatefulNotifier<BleCentralStatus> {
  BleScanner createScaner({required List<String> serviceIds});
  BleConnector createConnectorToKnownDevice(
      {required String deviceId, required List<String> serviceIds});
  bool get isCreateConnectorToKnownDeviceSupported;
}

enum BleCentralStatus {
  unknown,
  unsupported,
  unsupportedBrowser,
  unauthorized,
  poweredOff,
  locationServicesDisabled,
  ready
}
