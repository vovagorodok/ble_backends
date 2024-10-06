import 'package:bluez/bluez.dart';
import 'package:ble_backend/ble_central.dart';
import 'package:ble_backend/ble_scanner.dart';
import 'package:ble_backend/ble_connector.dart';
import 'package:bluez_backend/bluez_scanner.dart';

class BlueZCentral extends BleCentral {
  BlueZCentral({required this.client}) {
    _init();
  }

  final BlueZClient client;
  BleCentralStatus _status = BleCentralStatus.unknown;

  @override
  BleCentralStatus get state => _status;

  @override
  BleScanner createScaner({required List<String> serviceIds}) {
    return BlueZScanner(client: client, serviceIds: serviceIds);
  }

  @override
  BleConnector createConnectorToKnownDevice(
      {required String deviceId, required List<String> serviceIds}) {
    throw UnsupportedError;
  }

  @override
  bool get isCreateConnectorToKnownDeviceSupported => false;

  void _updateCentralStatus(BleCentralStatus status) {
    _status = status;
    notifyState(_status);
  }

  Future<void> _init() async {
    await client.connect();

    int attempts = 0;
    do {
      await Future.delayed(const Duration(milliseconds: 100));
      attempts++;
    } while (attempts < 10 && client.adapters.isEmpty);

    if (client.adapters.isEmpty) {
      _updateCentralStatus(BleCentralStatus.unsupported);
    } else {
      _updateCentralStatus(client.adapters.first.powered
          ? BleCentralStatus.ready
          : BleCentralStatus.poweredOff);
    }
  }
}
