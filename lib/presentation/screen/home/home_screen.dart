import 'package:code_challenge/navigation/app_navigator.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // go to photo screen button
            ElevatedButton(
              onPressed: () {
                AppNavigators.gotoPhotos(context: context);
              },
              child: const Text('Go to Photo Screen'),
            ),
            // goto bluetooth screen button
            ElevatedButton(
              onPressed: () {
                AppNavigators.gotoBluetooth(context: context);
              },
              child: const Text('Go to Bluetooth Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
