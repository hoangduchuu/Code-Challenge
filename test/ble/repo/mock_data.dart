import 'dart:typed_data';

import 'package:code_challenge/service/bluetooth/model/bluetooth_device_model.dart';
import 'package:code_challenge/service/bluetooth/model/connection_state.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class MockData {
  // Device IDs
  static const String testDeviceId = 'test_device';
  static const String device1Id = 'device1';
  static const String device2Id = 'device2';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);

  // RSSI values
  static const int rssiDevice1 = -60;
  static const int rssiDevice2 = -70;

  // Connection state sequences
  static const List<ConnectionState> fullConnectionStates = [
    ConnectionState.disconnected,
    ConnectionState.connecting,
    ConnectionState.connected,
    ConnectionState.disconnecting,
    ConnectionState.disconnected,
  ];

  static const List<ConnectionState> shortConnectionStates = [
    ConnectionState.connecting,
    ConnectionState.connected,
  ];

  static const List<ConnectionState> connectionFailureStates = [
    ConnectionState.connecting,
    ConnectionState.disconnected,
  ];

  // BLE Status values
  static const List<bool> bleStatusSequence = [true, false, true];
  static const List<BleStatus> bleStates = [
    BleStatus.ready,
    BleStatus.poweredOff,
    BleStatus.ready,
  ];

  // Bluetooth Device Models
  static BluetoothDeviceModel get device1 => BluetoothDeviceModel(
        id: '1',
        name: 'Device 1',
        isConnected: false,
        lastConnected: DateTime.now(),
        rssi: rssiDevice1,
      );

  static BluetoothDeviceModel get device2 => BluetoothDeviceModel(
        id: '2',
        name: 'Device 2',
        isConnected: false,
        lastConnected: DateTime.now(),
        rssi: rssiDevice2,
      );

  // Discovered Devices
  static DiscoveredDevice get discoveredDevice1 => DiscoveredDevice(
        id: '1',
        name: 'Device 1',
        serviceData: const {},
        manufacturerData: Uint8List.fromList([]),
        rssi: rssiDevice1,
        serviceUuids: const [],
      );

  static DiscoveredDevice get discoveredDevice2 => DiscoveredDevice(
        id: '2',
        name: 'Device 2',
        serviceData: const {},
        manufacturerData: Uint8List.fromList([]),
        rssi: rssiDevice2,
        serviceUuids: const [],
      );

  // Connection State Updates
  static ConnectionStateUpdate getConnectionStateUpdate({
    required String deviceId,
    required DeviceConnectionState state,
  }) {
    return ConnectionStateUpdate(
      deviceId: deviceId,
      connectionState: state,
      failure: null,
    );
  }

  // Predefined Lists
  static final emptyDeviceList = <BluetoothDeviceModel>[];
  static final singleDeviceList = [device1];
  static final twoDevicesList = [device1, device2];
}
