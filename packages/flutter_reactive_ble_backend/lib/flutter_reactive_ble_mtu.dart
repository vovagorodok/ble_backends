import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:ble_backend/ble_mtu.dart';

class FlutterReactiveBleMtu extends BleMtu {
  FlutterReactiveBleMtu({
    required FlutterReactiveBle backend,
    required String deviceId,
  })  : _backend = backend,
        _deviceId = deviceId;

  final FlutterReactiveBle _backend;
  final String _deviceId;

  @override
  Future<int> request({required int mtu}) async {
    return await _backend.requestMtu(deviceId: _deviceId, mtu: mtu);
  }

  @override
  bool get isRequestSupported => true;
}
