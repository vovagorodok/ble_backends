import 'package:ble_backend/ble_connector.dart';

abstract class BlePeripheral {
  String get id;
  String? get name;
  int? get rssi;
  BleConnector createConnector();
}
