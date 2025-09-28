import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ble_backend/ble_peripheral.dart';
import 'package:ble_backend/ble_connector.dart';
import 'package:ble_backend_screens/ui/ui_consts.dart';

class PeripheralScreen extends StatefulWidget {
  const PeripheralScreen({
    required this.blePeripheral,
    required this.bleConnector,
    super.key,
  });

  final BlePeripheral blePeripheral;
  final BleConnector bleConnector;

  @override
  State<PeripheralScreen> createState() => PeripheralScreenState();
}

class PeripheralScreenState extends State<PeripheralScreen> {
  StreamSubscription? _subscription;
  List<String> _services = [];

  BlePeripheral get blePeripheral => widget.blePeripheral;
  BleConnector get bleConnector => widget.bleConnector;
  BleConnectorStatus get connectionStatus => bleConnector.state;

  Future<void> _discoverServices() async {
    _services = await bleConnector.discoverServices();
    setState(() {});
  }

  void _onConnectionStateChanged(BleConnectorStatus state) {
    setState(() {
      if (state == BleConnectorStatus.connected) {
        _discoverServices();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _subscription = bleConnector.stateStream.listen(_onConnectionStateChanged);
    bleConnector.connect();
  }

  @override
  void dispose() {
    () async {
      await bleConnector.disconnect();
      await _subscription?.cancel();
    }.call();
    bleConnector.dispose();
    super.dispose();
  }

  Widget _buildStatusText(String text) {
    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
            )),
      ),
    );
  }

  Widget _buildStatusWidget() {
    if (connectionStatus == BleConnectorStatus.connecting) {
      return _buildStatusText('Connecting..');
    } else if (connectionStatus == BleConnectorStatus.disconnecting) {
      return _buildStatusText('Disconnecting..');
    } else if (connectionStatus == BleConnectorStatus.disconnected) {
      return _buildStatusText('Disconnected');
    } else if (connectionStatus == BleConnectorStatus.scanning) {
      return _buildStatusText('Scanning..');
    } else {
      return _buildStatusText('Connected');
    }
  }

  Widget _buildServicesList() {
    return ListView.builder(
        itemCount: _services.length,
        itemBuilder: (context, index) => Card(
                child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                _services[index],
                textAlign: TextAlign.center,
              ),
            )));
  }

  Widget _buildPortrait() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildStatusWidget(),
          const SizedBox(height: screenPortraitSplitter),
          Expanded(
            child: _buildServicesList(),
          ),
        ],
      );

  Widget _buildLandscape() => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildStatusWidget(),
          ),
          const SizedBox(width: screenLandscapeSplitter),
          Expanded(
            child: _buildServicesList(),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        primary: MediaQuery.of(context).orientation == Orientation.portrait,
        appBar: AppBar(
          title: Text(blePeripheral.name ?? ''),
          centerTitle: true,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: SafeArea(
          minimum: const EdgeInsets.all(screenPadding),
          child: OrientationBuilder(
            builder: (context, orientation) =>
                orientation == Orientation.portrait
                    ? _buildPortrait()
                    : _buildLandscape(),
          ),
        ),
      );
}
