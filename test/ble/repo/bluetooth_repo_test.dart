import 'dart:async';

import 'package:code_challenge/data/database/handler/stored_deivce_handler.dart';
import 'package:code_challenge/data/repository/bluetooth_repository_impl.dart';
import 'package:code_challenge/service/bluetooth/bluetooth_interface.dart';
import 'package:code_challenge/service/bluetooth/model/bluetooth_device_model.dart';
import 'package:code_challenge/service/bluetooth/model/connection_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'bluetooth_repo_test.mocks.dart';
import 'mock_data.dart';


@GenerateMocks([IBluetoothInterface, StoredDeviceHandler])
void main() {
  late MockIBluetoothInterface mockBluetooth;
  late MockStoredDeviceHandler mockHandler;
  late BluetoothRepositoryImpl repository;

  setUp(() {
    mockBluetooth = MockIBluetoothInterface();
    mockHandler = MockStoredDeviceHandler();
    repository = BluetoothRepositoryImpl(mockBluetooth, mockHandler);
  });

  group('BluetoothRepositoryImpl', () {
    test('initialize should forward to bluetooth interface', () async {
      when(mockBluetooth.initialize()).thenAnswer((_) async => true);
      final result = await repository.initialize();
      expect(result, true);
      verify(mockBluetooth.initialize()).called(1);
    });

    test('initialize should handle failure from bluetooth interface', () async {
      when(mockBluetooth.initialize()).thenAnswer((_) async => false);
      final result = await repository.initialize();
      expect(result, false);
      verify(mockBluetooth.initialize()).called(1);
    });

    test('isEnabled should forward stream from bluetooth interface', () async {
      final statusController = StreamController<bool>();
      when(mockBluetooth.isEnabled()).thenAnswer((_) => statusController.stream);

      expectLater(
        repository.isEnabled,
        emitsInOrder(MockData.bleStatusSequence),
      );

      for (final status in MockData.bleStatusSequence) {
        statusController.add(status);
      }
    });

    test('discoveredDevices should forward stream from bluetooth interface', () async {
      final devicesController = StreamController<List<BluetoothDeviceModel>>();
      when(mockBluetooth.discoveredDevices()).thenAnswer((_) => devicesController.stream);

      expectLater(
        repository.discoveredDevices,
        emitsInOrder([
          MockData.singleDeviceList,
          MockData.twoDevicesList,
        ]),
      );

      devicesController.add(MockData.singleDeviceList);
      devicesController.add(MockData.twoDevicesList);
    });

    test('discoveredDevices should handle empty device list', () async {
      final devicesController = StreamController<List<BluetoothDeviceModel>>();
      when(mockBluetooth.discoveredDevices()).thenAnswer((_) => devicesController.stream);

      expectLater(
        repository.discoveredDevices,
        emitsInOrder([
          MockData.emptyDeviceList,
          MockData.singleDeviceList,
          MockData.emptyDeviceList,
        ]),
      );

      devicesController.add(MockData.emptyDeviceList);
      devicesController.add(MockData.singleDeviceList);
      devicesController.add(MockData.emptyDeviceList);
    });

    test('connectionStateStream should handle all possible states', () async {
      final stateController = StreamController<ConnectionState>();
      when(mockBluetooth.connectionStateStream(MockData.testDeviceId)).thenAnswer((_) => stateController.stream);

      expectLater(
        repository.connectionStateStream(MockData.testDeviceId),
        emitsInOrder(MockData.fullConnectionStates),
      );

      for (final state in MockData.fullConnectionStates) {
        stateController.add(state);
      }
    });

    test('connectionStateStream should handle multiple device IDs', () async {
      final stateController1 = StreamController<ConnectionState>();
      final stateController2 = StreamController<ConnectionState>();

      when(mockBluetooth.connectionStateStream(MockData.device1Id)).thenAnswer((_) => stateController1.stream);
      when(mockBluetooth.connectionStateStream(MockData.device2Id)).thenAnswer((_) => stateController2.stream);

      expectLater(
        repository.connectionStateStream(MockData.device1Id),
        emitsInOrder(MockData.shortConnectionStates),
      );

      expectLater(
        repository.connectionStateStream(MockData.device2Id),
        emitsInOrder(MockData.connectionFailureStates),
      );

      stateController1.add(ConnectionState.connecting);
      stateController2.add(ConnectionState.connecting);
      stateController1.add(ConnectionState.connected);
      stateController2.add(ConnectionState.disconnected);
    });

    test('should manage multiple simultaneous connections', () async {
      when(mockBluetooth.connect(MockData.device1Id)).thenAnswer((_) async => true);
      when(mockBluetooth.connect(MockData.device2Id)).thenAnswer((_) async => true);

      final result1 = await repository.connect(MockData.device1Id);
      final result2 = await repository.connect(MockData.device2Id);

      expect(result1, true);
      expect(result2, true);
      verify(mockBluetooth.connect(MockData.device1Id)).called(1);
      verify(mockBluetooth.connect(MockData.device2Id)).called(1);
    });

    test('should handle disconnect during connection attempt', () async {
      final stateController = StreamController<ConnectionState>();
      when(mockBluetooth.connectionStateStream(MockData.testDeviceId)).thenAnswer((_) => stateController.stream);

      expectLater(
        repository.connectionStateStream(MockData.testDeviceId),
        emitsInOrder(MockData.connectionFailureStates),
      );

      for (final state in MockData.connectionFailureStates) {
        stateController.add(state);
      }
    });
  });
}
