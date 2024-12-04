// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:code_challenge/service/bluetooth/bluetooth_interface.dart';
import 'package:code_challenge/service/bluetooth/filter.dart';

// ignore: depend_on_referenced_packages
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../model/bluetooth_device_model.dart';
import '../model/connection_state.dart';

class BluetoothBluePlusImpl implements IBluetoothInterface {
  Timer? _scanTimeout;
  final _deviceController = StreamController<List<BluetoothDeviceModel>>.broadcast();
  final Map<String, StreamSubscription> _connectionSubscriptions = {};

  @override
  Future<bool> initialize() async {
    try {
      return await FlutterBluePlus.isSupported;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> enableBluetooth() async {
    try {
      await FlutterBluePlus.turnOn(timeout: 60);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> disableBluetooth() async {
    // Note: turnOff is deprecated in Android SDK 33
    return false;
  }

  @override
  Stream<bool> isEnabled() =>
      FlutterBluePlus.adapterState
          .map((state) => state == BluetoothAdapterState.on);

  @override
  Future<void> startScan() async {
    try {
      if (await FlutterBluePlus.isScanning.first) {
        await stopScan();
      }

      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 30),
        androidScanMode: AndroidScanMode.lowLatency,
      );

      FlutterBluePlus.scanResults.listen((results) {
        final devices = results.map((result) {
          final isConnected = FlutterBluePlus.connectedDevices
              .any((d) => d.remoteId.str == result.device.remoteId.str);

          return BluetoothDeviceModel(
            id: result.device.remoteId.str,
            name: result.device.platformName.isEmpty
                ? result.advertisementData.advName
                : result.device.platformName,
            isConnected: isConnected,
            lastConnected: DateTime.now(),
            rssi: result.rssi,
          );
        }).toList();


        _deviceController.add(BluetoothDeviceFilter.filterDevices(devices));
      });

      _scanTimeout = Timer(const Duration(seconds: 30), stopScan);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> stopScan() async {
    _scanTimeout?.cancel();
    await FlutterBluePlus.stopScan();
  }

  @override
  Stream<List<BluetoothDeviceModel>> discoveredDevices() => _deviceController.stream;

  @override
  Future<bool> connect(String deviceId) async {
    try {
      final device = BluetoothDevice.fromId(deviceId);
      await device.connect(
        timeout: const Duration(seconds: 30),
        autoConnect: false,
      );

      _connectionSubscriptions[deviceId]?.cancel();
      _connectionSubscriptions[deviceId] = device.connectionState.listen((state) {
        if (state == BluetoothConnectionState.disconnected) {
          _connectionSubscriptions[deviceId]?.cancel();
          _connectionSubscriptions.remove(deviceId);
        }
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> disconnect(String deviceId) async {
    try {
      final device = BluetoothDevice.fromId(deviceId);
      await device.disconnect();
      _connectionSubscriptions[deviceId]?.cancel();
      _connectionSubscriptions.remove(deviceId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<ConnectionState> connectionStateStream(String deviceId) {
    final device = BluetoothDevice.fromId(deviceId);
    return device.connectionState.map((state) {
      switch (state) {
        case BluetoothConnectionState.disconnected:
          return ConnectionState.disconnected;
        case BluetoothConnectionState.connecting:
          return ConnectionState.connecting;
        case BluetoothConnectionState.connected:
          return ConnectionState.connected;
        case BluetoothConnectionState.disconnecting:
          return ConnectionState.disconnecting;
      }
    });
  }

  @override
  Future<List<BluetoothDeviceModel>> getSystemConnectedDevices() async {
    final connectedDevices = FlutterBluePlus.connectedDevices;
    final systemDevices = await FlutterBluePlus.systemDevices([]);

    final allDevices = {...connectedDevices, ...systemDevices};

    return allDevices.map((device) =>
        BluetoothDeviceModel(
          id: device.remoteId.str,
          name: device.platformName.isEmpty ? 'Unknown Device' : device.platformName,
          isConnected: connectedDevices.contains(device),
          lastConnected: DateTime.now(),
          rssi: 0,
        )).toList();
  }

  @override
  void dispose() {
    _deviceController.close();
    _scanTimeout?.cancel();
    for (var subscription in _connectionSubscriptions.values) {
      subscription.cancel();
    }
    _connectionSubscriptions.clear();
  }
}