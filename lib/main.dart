import 'package:code_challenge/core/di/service_locator.dart';
import 'package:code_challenge/presentation/screen/bluethooth/bluetooth_screen.dart';
import 'package:flutter/material.dart';


void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const BluetoothScreen(),
    );
  }
}
