// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:code_challenge/service/bluetooth/bluetooth_interface.dart';
import 'package:code_challenge/service/bluetooth/filter.dart';
import 'package:code_challenge/service/bluetooth/model/bluetooth_device_model.dart';
import 'package:code_challenge/service/bluetooth/model/connection_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BluetoothReactiveBleImpl implements IBluetoothInterface {
  final FlutterReactiveBle _ble;
  final _deviceController = StreamController<List<BluetoothDeviceModel>>.broadcast();
  final Map<String, StreamSubscription> _connectionSubscriptions = {};
  final Map<String, ConnectionState> _deviceConnectionStates = {};

  BluetoothReactiveBleImpl() : _ble = FlutterReactiveBle();

  // Add this constructor for testing
  @visibleForTesting
  BluetoothReactiveBleImpl.withBle(this._ble);

  @override
  Future<bool> initialize() async {
    try {
      return true; // ReacticeBle doesn't have explicit initialization
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> enableBluetooth() async {
    return false; // ReacticeBle can't control bluetooth state
  }

  @override
  Future<bool> disableBluetooth() async {
    return false; // ReacticeBle can't control bluetooth state
  }

  @override
  Stream<bool> isEnabled() => _ble.statusStream.map((status) => status == BleStatus.ready);

  @override
  Future<void> startScan() async {
    try {
      final discoveredDevices = <BluetoothDeviceModel>[];

      _ble.scanForDevices(
        withServices: [],
        scanMode: ScanMode.lowLatency,
      ).listen((device) {
        final bleDevice = BluetoothDeviceModel(
          id: device.id,
          name: device.name.isEmpty ? 'Unknown Device' : device.name,
          isConnected: _deviceConnectionStates[device.id] == ConnectionState.connected,
          lastConnected: DateTime.now(),
          rssi: device.rssi,
        );

        final index = discoveredDevices.indexWhere((d) => d.id == device.id);
        if (index >= 0) {
          discoveredDevices[index] = bleDevice;
        } else {
          discoveredDevices.add(bleDevice);
        }

        _deviceController.add(BluetoothDeviceFilter.filterDevices(discoveredDevices));
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> stopScan() async {
    // Reactice Ble handles scan timeout automatically
  }

  @override
  Stream<List<BluetoothDeviceModel>> discoveredDevices() => _deviceController.stream;

  @override
  Future<bool> connect(String deviceId) async {
    try {
      _connectionSubscriptions[deviceId]?.cancel();

      _connectionSubscriptions[deviceId] = _ble
          .connectToDevice(
        id: deviceId,
        connectionTimeout: const Duration(seconds: 30),
      )
          .listen((state) {
        _deviceConnectionStates[deviceId] = _mapConnectionState(state.connectionState);

        if (state.connectionState == DeviceConnectionState.disconnected) {
          _connectionSubscriptions[deviceId]?.cancel();
          _connectionSubscriptions.remove(deviceId);
          _deviceConnectionStates.remove(deviceId);
        }
      });

      await _connectionSubscriptions[deviceId]?.asFuture();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> disconnect(String deviceId) async {
    _connectionSubscriptions[deviceId]?.cancel();
    _connectionSubscriptions.remove(deviceId);
    _deviceConnectionStates.remove(deviceId);
  }

  @override
  Stream<ConnectionState> connectionStateStream(String deviceId) {
    return _ble.connectToDevice(id: deviceId).map((state) => _mapConnectionState(state.connectionState));
  }

  ConnectionState _mapConnectionState(DeviceConnectionState state) {
    switch (state) {
      case DeviceConnectionState.disconnected:
        return ConnectionState.disconnected;
      case DeviceConnectionState.connecting:
        return ConnectionState.connecting;
      case DeviceConnectionState.connected:
        return ConnectionState.connected;
      case DeviceConnectionState.disconnecting:
        return ConnectionState.disconnecting;
    }
  }

  @override
  Future<List<BluetoothDeviceModel>> getSystemConnectedDevices() async {
    // Reactice Ble doesn't support getting system connected devices directly
    // We'll return devices we know are connected through our app
    return _deviceConnectionStates.entries
        .where((entry) => entry.value == ConnectionState.connected)
        .map((entry) => BluetoothDeviceModel(
              id: entry.key,
              name: 'Unknown Device',
              // We don't have names stored
              isConnected: true,
              lastConnected: DateTime.now(),
              rssi: 0,
            ))
        .toList();
  }

  @override
  void dispose() {
    _deviceController.close();
    for (var subscription in _connectionSubscriptions.values) {
      subscription.cancel();
    }
    _connectionSubscriptions.clear();
    _deviceConnectionStates.clear();
  }
}
