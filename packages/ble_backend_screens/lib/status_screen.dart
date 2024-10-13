import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:ble_backend/ble_central.dart';
import 'package:ble_backend_screens/ui/ui_consts.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({
    required this.bleCentral,
    super.key,
  });

  final BleCentral bleCentral;

  @override
  State<StatusScreen> createState() => StatusScreenState();
}

class StatusScreenState extends State<StatusScreen> {
  BleCentral get bleCentral => widget.bleCentral;

  String _determineText(BleCentralStatus status) {
    switch (status) {
      case BleCentralStatus.unsupported:
        return 'This device does not support Bluetooth';
      case BleCentralStatus.unsupportedBrowser:
        return 'This browser does not support Bluetooth';
      case BleCentralStatus.unauthorized:
        return 'Authorize application to use Bluetooth and location';
      case BleCentralStatus.poweredOff:
        return 'Bluetooth is disabled, turn it on';
      case BleCentralStatus.locationServicesDisabled:
        return 'Location services are disabled, enable them';
      case BleCentralStatus.ready:
        return 'Bluetooth is up and running';
      default:
        return 'Waiting to fetch Bluetooth status: $status';
    }
  }

  IconData _determineIcon(BleCentralStatus status) {
    switch (status) {
      case BleCentralStatus.unsupported:
        return Icons.bluetooth_disabled_rounded;
      case BleCentralStatus.unsupportedBrowser:
        return Icons.browser_not_supported_rounded;
      case BleCentralStatus.unauthorized:
        return Icons.person_off_rounded;
      case BleCentralStatus.poweredOff:
        return Icons.bluetooth_disabled_rounded;
      case BleCentralStatus.locationServicesDisabled:
        return Icons.location_off_rounded;
      case BleCentralStatus.ready:
        return Icons.bluetooth_rounded;
      default:
        return Icons.autorenew_rounded;
    }
  }

  void _evaluateBleCentralStatus(BleCentralStatus status) {
    setState(() {
      if (status == BleCentralStatus.ready) {
        Navigator.pop(context);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    bleCentral.stateStream.listen(_evaluateBleCentralStatus);
    () async {
      if (!Platform.isAndroid && !Platform.isIOS && !Platform.isWindows) return;

      if (Platform.isAndroid) {
        final deviceInfo = DeviceInfoPlugin();
        final androidInfo = await deviceInfo.androidInfo;
        final sdkVersion = androidInfo.version.sdkInt;
        if (sdkVersion < 31) {
          await Permission.location.request();
        }
      }
      await Permission.bluetooth.request();
      await Permission.bluetoothScan.request();
      await Permission.bluetoothAdvertise.request();
      await Permission.bluetoothConnect.request();
    }.call();
    _evaluateBleCentralStatus(bleCentral.state);
  }

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: false,
        child: Scaffold(
          body: SafeArea(
            minimum: const EdgeInsets.all(screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _determineText(bleCentral.state),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                  ),
                ),
                const SizedBox(height: 20),
                Icon(
                  _determineIcon(bleCentral.state),
                  size: 100,
                ),
              ],
            ),
          ),
        ),
      );
}
