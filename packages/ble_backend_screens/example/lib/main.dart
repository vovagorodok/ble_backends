import 'package:flutter/material.dart';
import 'package:ble_backend_factory/ble_central.dart';
import 'package:ble_backend_screens/status_screen.dart';
import 'package:ble_backend_screens/scanner_screen.dart';
import 'package:ble_backend_screens_example/screens/peripheral_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ble backend screens example',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
      ),
      home: ScannerScreen(
        bleCentral: bleCentral,
        bleScanner: bleCentral.createScanner(serviceIds: []),
        createStatusScreen: (bleCentral) =>
            StatusScreen(bleCentral: bleCentral),
        createPeripheralScreen: (blePeripheral) => PeripheralScreen(
            blePeripheral: blePeripheral,
            bleConnector: blePeripheral.createConnector()),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
