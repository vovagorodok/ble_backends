import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:ble_backend/ble_central.dart';
import 'package:ble_backend/ble_scanner.dart';
import 'package:ble_backend/ble_peripheral.dart';
import 'package:ble_backend/utils/timer_wrapper.dart';
import 'package:ble_backend_screens/ui/ui_consts.dart';
import 'package:ble_backend_screens/ui/jumping_dots.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({
    required this.bleCentral,
    required this.bleScanner,
    required this.createStatusScreen,
    required this.createPeripheralScreen,
    super.key,
  });

  final BleCentral bleCentral;
  final BleScanner bleScanner;
  final Widget Function(BleCentral) createStatusScreen;
  final Widget Function(BlePeripheral) createPeripheralScreen;

  @override
  State<ScannerScreen> createState() => ScannerScreenState();
}

class ScannerScreenState extends State<ScannerScreen> {
  final scanTimer = TimerWrapper();

  BleCentral get bleCentral => widget.bleCentral;
  BleScanner get bleScanner => widget.bleScanner;

  void _evaluateBleCentralStatus(BleCentralStatus status) {
    setState(() {
      if (kIsWeb) {
      } else if (status == BleCentralStatus.ready) {
        _startScan();
      } else if (status != BleCentralStatus.unknown) {
        _stopScan();
      }

      if (status != BleCentralStatus.ready &&
          status != BleCentralStatus.unknown) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => widget.createStatusScreen(bleCentral)),
        );
      }
    });
  }

  void _startScan() {
    WakelockPlus.enable();
    bleScanner.scan();

    scanTimer.start(const Duration(seconds: 10), _stopScan);
  }

  void _stopScan() {
    scanTimer.stop();
    WakelockPlus.disable();
    bleScanner.stop();
  }

  Widget _buildDeviceCard(device) => Card(
        child: ListTile(
          title: Text(device.name ?? ''),
          subtitle: Text("${device.id}\nRSSI: ${device.rssi ?? ''}"),
          leading: const Icon(Icons.bluetooth_rounded),
          onTap: () async {
            _stopScan();
            await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => widget.createPeripheralScreen(device)),
            );
          },
        ),
      );

  Widget _buildDevicesList() {
    final devices = bleScanner.state.devices;
    final additionalElement = bleScanner.state.isScanInProgress ? 1 : 0;

    return ListView.builder(
      itemCount: devices.length + additionalElement,
      itemBuilder: (context, index) => index != devices.length
          ? _buildDeviceCard(devices[index])
          : Padding(
              padding: const EdgeInsets.all(25.0),
              child: createJumpingDots(),
            ),
    );
  }

  Widget _buildScanButton() => FilledButton.icon(
        icon: const Icon(Icons.search_rounded),
        label: const Text('Scan'),
        onPressed: !bleScanner.state.isScanInProgress ? _startScan : null,
      );

  Widget _buildStopButton() => FilledButton.icon(
        icon: const Icon(Icons.search_off_rounded),
        label: const Text('Stop'),
        onPressed: bleScanner.state.isScanInProgress ? _stopScan : null,
      );

  Widget _buildControlButtons() => SizedBox(
        height: buttonHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _buildScanButton(),
            ),
            if (!kIsWeb) const SizedBox(width: buttonsSplitter),
            if (!kIsWeb)
              Expanded(
                child: _buildStopButton(),
              ),
          ],
        ),
      );

  Widget _buildPortrait() => Column(
        children: [
          Expanded(
            child: _buildDevicesList(),
          ),
          const SizedBox(height: screenPortraitSplitter),
          _buildControlButtons(),
        ],
      );

  Widget _buildLandscape() => Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: _buildDevicesList(),
          ),
          const SizedBox(width: screenLandscapeSplitter),
          Expanded(
            child: _buildControlButtons(),
          ),
        ],
      );

  @override
  void initState() {
    super.initState();
    bleCentral.stateStream.listen(_evaluateBleCentralStatus);
    _evaluateBleCentralStatus(bleCentral.state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: MediaQuery.of(context).orientation == Orientation.portrait,
      appBar: AppBar(
        title: const Text('Devices'),
        centerTitle: true,
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(screenPadding),
        child: StreamBuilder<BleScannerState>(
          stream: bleScanner.stateStream,
          builder: (context, snapshot) => OrientationBuilder(
            builder: (context, orientation) =>
                orientation == Orientation.portrait
                    ? _buildPortrait()
                    : _buildLandscape(),
          ),
        ),
      ),
    );
  }
}
