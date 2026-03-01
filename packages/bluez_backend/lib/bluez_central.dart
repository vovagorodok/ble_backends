import 'package:bluez/bluez.dart';
import 'package:ble_backend/ble_central.dart';
import 'package:ble_backend/ble_scanner.dart';
import 'package:ble_backend/ble_connector.dart';
import 'package:bluez_backend/bluez_scanner.dart';

class BlueZCentral extends BleCentral {
  BlueZCentral({required BlueZClient client}) : _client = client {
    _init();
  }

  final BlueZClient _client;
  BleCentralStatus _status = BleCentralStatus.unknown;

  @override
  BleCentralStatus get state => _status;

  @override
  BleScanner createScanner({required List<String> serviceIds}) {
    return BlueZScanner(client: _client, serviceIds: serviceIds);
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
    await _client.connect();

    int attempts = 0;
    do {
      await Future.delayed(const Duration(milliseconds: 100));
      attempts++;
    } while (attempts < 10 && _client.adapters.isEmpty);

    if (_client.adapters.isEmpty) {
      _updateCentralStatus(BleCentralStatus.unsupported);
    } else {
      _updateCentralStatus(_client.adapters.first.powered
          ? BleCentralStatus.ready
          : BleCentralStatus.poweredOff);
    }
  }
}
