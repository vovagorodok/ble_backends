import 'dart:async';

import 'package:universal_ble/universal_ble.dart';
import 'package:ble_backend/ble_mtu.dart';

class UniversalBleMtu extends BleMtu {
  UniversalBleMtu({required String deviceId}) : _deviceId = deviceId;

  final String _deviceId;

  @override
  Future<int> request({required int mtu}) async {
    return await UniversalBle.requestMtu(_deviceId, mtu);
  }

  @override
  bool get isRequestSupported => true;
}
