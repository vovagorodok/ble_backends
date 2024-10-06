import 'dart:async';

import 'package:universal_ble/universal_ble.dart';
import 'package:ble_backend/ble_mtu.dart';

class UniversalBleMtu extends BleMtu {
  UniversalBleMtu({required this.deviceId});

  final String deviceId;

  @override
  Future<int> request({required int mtu}) async {
    return await UniversalBle.requestMtu(deviceId, mtu);
  }

  @override
  bool get isRequestSupported => true;
}
