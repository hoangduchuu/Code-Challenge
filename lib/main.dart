import 'package:code_challenge/core/di/service_locator.dart';
import 'package:code_challenge/data/database/local_setup/local_database_service.dart';
import 'package:code_challenge/presentation/screen/bluethooth/bluetooth_screen.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await locator.get<LocalDatabaseService>().initialize();
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
