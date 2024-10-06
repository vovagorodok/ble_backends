import 'dart:async';

import 'package:meta/meta.dart';
import 'package:ble_backend/state_notifier.dart';
import 'package:ble_backend/ble_peripheral.dart';

abstract class BleScanner extends StatefulNotifier<BleScannerState> {
  Future<void> scan();
  Future<void> stop();
}

@immutable
class BleScannerState {
  const BleScannerState({
    required this.devices,
    required this.isScanInProgress,
  });

  final List<BlePeripheral> devices;
  final bool isScanInProgress;
}
