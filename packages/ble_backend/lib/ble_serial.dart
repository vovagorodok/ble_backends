import 'dart:async';
import 'dart:typed_data';

import 'package:ble_backend/data_notifier.dart';
import 'package:ble_backend/ble_characteristic.dart';
import 'package:ble_backend/utils/timer_wrapper.dart';

class BleSerial extends DataNotifier<Uint8List> {
  BleSerial({
    required BleCharacteristic characteristicRx,
    required BleCharacteristic characteristicTx,
  })  : _characteristicRx = characteristicRx,
        _characteristicTx = characteristicTx {
    _subscription = _characteristicRx.dataStream.listen((data) {
      _responseGuard.stop();
      notifyData(data);
    });
  }

  final BleCharacteristic _characteristicRx;
  final BleCharacteristic _characteristicTx;
  final _responseGuard = TimerWrapper();
  StreamSubscription? _subscription;

  Future<void> send({required Uint8List data}) async {
    await _characteristicTx.writeWithoutResponse(data: data);
  }

  void waitData({
    required void Function() timeoutCallback,
    Duration duration = const Duration(seconds: 20),
  }) {
    _responseGuard.start(duration, timeoutCallback);
  }

  Future<void> startNotifications() async {
    await _characteristicRx.startNotifications();
  }

  Future<void> stopNotifications() async {
    await _characteristicRx.stopNotifications();
    _responseGuard.stop();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _responseGuard.stop();
    super.dispose();
  }
}
