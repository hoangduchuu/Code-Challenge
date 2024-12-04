import 'dart:async';

import 'package:code_challenge/service/bluetooth/flutter_reactive_ble/bluethooth_reactive_ble_impl.dart';
import 'package:code_challenge/service/bluetooth/model/bluetooth_device_model.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'ble_reactive_repo_test.mocks.dart';
import 'repo/mock_data.dart';

@GenerateMocks([FlutterReactiveBle])
void main() {
  late MockFlutterReactiveBle mockBle;
  late BluetoothReactiveBleImpl bluetoothService;

  setUp(() {
    mockBle = MockFlutterReactiveBle();
    when(mockBle.statusStream).thenAnswer((_) => Stream.value(BleStatus.ready));
    bluetoothService = BluetoothReactiveBleImpl.withBle(mockBle);
  });

  tearDown(() {
    bluetoothService.dispose();
  });

  group('BluetoothReactiveBleImpl', () {
    test('initialize should return true', () async {
      final result = await bluetoothService.initialize();
      expect(result, true);
    });

    test('isEnabled should map BleStatus correctly', () async {
      final statusController = StreamController<BleStatus>();
      when(mockBle.statusStream).thenAnswer((_) => statusController.stream);

      expectLater(
        bluetoothService.isEnabled(),
        emitsInOrder(MockData.bleStatusSequence),
      );

      for (final state in MockData.bleStates) {
        statusController.add(state);
      }
    });

    test('startScan should discover devices correctly', () async {
      final scanController = StreamController<DiscoveredDevice>();
      when(mockBle.scanForDevices(
        withServices: [],
        scanMode: ScanMode.lowLatency,
      )).thenAnswer((_) => scanController.stream);

      await bluetoothService.startScan();

      expectLater(
        bluetoothService.discoveredDevices(),
        emitsInOrder([
          predicate<List<BluetoothDeviceModel>>(
              (devices) => devices.length == 1 && devices[0].id == MockData.device1.id),
          predicate<List<BluetoothDeviceModel>>((devices) =>
              devices.length == 2 && devices[0].id == MockData.device1.id && devices[1].id == MockData.device2.id),
        ]),
      );

      scanController.add(MockData.discoveredDevice1);
      scanController.add(MockData.discoveredDevice2);
    });

    test('connect should handle connection states correctly', () async {
      final connectionController = StreamController<ConnectionStateUpdate>();

      when(mockBle.connectToDevice(
        id: anyNamed('id'),
        servicesWithCharacteristicsToDiscover: anyNamed('servicesWithCharacteristicsToDiscover'),
        connectionTimeout: anyNamed('connectionTimeout'),
      )).thenAnswer((_) {
        connectionController.add(
          MockData.getConnectionStateUpdate(
            deviceId: MockData.testDeviceId,
            state: DeviceConnectionState.connected,
          ),
        );
        connectionController.close();
        return connectionController.stream;
      });

      final result = await bluetoothService.connect(MockData.testDeviceId);

      expect(result, true);

      verify(mockBle.connectToDevice(
        id: anyNamed('id'),
        servicesWithCharacteristicsToDiscover: anyNamed('servicesWithCharacteristicsToDiscover'),
        connectionTimeout: anyNamed('connectionTimeout'),
      )).called(1);
    });

    test('should emit correct connection states', () async {
      final connectionController = StreamController<ConnectionStateUpdate>();

      when(mockBle.connectToDevice(
        id: anyNamed('id'),
        servicesWithCharacteristicsToDiscover: anyNamed('servicesWithCharacteristicsToDiscover'),
        connectionTimeout: anyNamed('connectionTimeout'),
      )).thenAnswer((_) => connectionController.stream);

      final states = bluetoothService.connectionStateStream(MockData.testDeviceId).take(2);

      expectLater(states, emitsInOrder(MockData.shortConnectionStates));

      connectionController.add(MockData.getConnectionStateUpdate(
        deviceId: MockData.testDeviceId,
        state: DeviceConnectionState.connecting,
      ));

      connectionController.add(MockData.getConnectionStateUpdate(
        deviceId: MockData.testDeviceId,
        state: DeviceConnectionState.connected,
      ));
    });

    test('disconnect should cancel connection subscription', () async {
      final connectionController = StreamController<ConnectionStateUpdate>();

      when(mockBle.connectToDevice(
        id: anyNamed('id'),
        servicesWithCharacteristicsToDiscover: anyNamed('servicesWithCharacteristicsToDiscover'),
        connectionTimeout: anyNamed('connectionTimeout'),
      )).thenAnswer((_) {
        connectionController.add(MockData.getConnectionStateUpdate(
          deviceId: MockData.testDeviceId,
          state: DeviceConnectionState.connected,
        ));
        connectionController.close();
        return connectionController.stream;
      });

      await bluetoothService.connect(MockData.testDeviceId);
      await bluetoothService.disconnect(MockData.testDeviceId);

      final verification = verify(mockBle.connectToDevice(
        id: captureAnyNamed('id'),
        servicesWithCharacteristicsToDiscover: captureAnyNamed('servicesWithCharacteristicsToDiscover'),
        connectionTimeout: captureAnyNamed('connectionTimeout'),
      ));

      verification.called(1);

      expect(verification.captured[0], MockData.testDeviceId);
      expect(verification.captured[1], null);
      expect(verification.captured[2], MockData.connectionTimeout);
    });
  });
}
