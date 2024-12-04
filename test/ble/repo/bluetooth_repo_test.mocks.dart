// Mocks generated by Mockito 5.4.4 from annotations
// in code_challenge/test/ble/repo/bluetooth_repo_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:code_challenge/data/database/dto/stored_device_data.dart'
    as _i8;
import 'package:code_challenge/data/database/handler/stored_deivce_handler.dart'
    as _i7;
import 'package:code_challenge/service/bluetooth/bluetooth_interface.dart'
    as _i3;
import 'package:code_challenge/service/bluetooth/model/bluetooth_device_model.dart'
    as _i5;
import 'package:code_challenge/service/bluetooth/model/connection_state.dart'
    as _i6;
import 'package:isar/isar.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeIsar_0 extends _i1.SmartFake implements _i2.Isar {
  _FakeIsar_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [IBluetoothInterface].
///
/// See the documentation for Mockito's code generation for more information.
class MockIBluetoothInterface extends _i1.Mock
    implements _i3.IBluetoothInterface {
  MockIBluetoothInterface() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<bool> initialize() => (super.noSuchMethod(
        Invocation.method(
          #initialize,
          [],
        ),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);

  @override
  _i4.Future<bool> enableBluetooth() => (super.noSuchMethod(
        Invocation.method(
          #enableBluetooth,
          [],
        ),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);

  @override
  _i4.Future<bool> disableBluetooth() => (super.noSuchMethod(
        Invocation.method(
          #disableBluetooth,
          [],
        ),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);

  @override
  _i4.Stream<bool> isEnabled() => (super.noSuchMethod(
        Invocation.method(
          #isEnabled,
          [],
        ),
        returnValue: _i4.Stream<bool>.empty(),
      ) as _i4.Stream<bool>);

  @override
  _i4.Future<void> startScan() => (super.noSuchMethod(
        Invocation.method(
          #startScan,
          [],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> stopScan() => (super.noSuchMethod(
        Invocation.method(
          #stopScan,
          [],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Stream<List<_i5.BluetoothDeviceModel>> discoveredDevices() =>
      (super.noSuchMethod(
        Invocation.method(
          #discoveredDevices,
          [],
        ),
        returnValue: _i4.Stream<List<_i5.BluetoothDeviceModel>>.empty(),
      ) as _i4.Stream<List<_i5.BluetoothDeviceModel>>);

  @override
  _i4.Future<bool> connect(String? deviceId) => (super.noSuchMethod(
        Invocation.method(
          #connect,
          [deviceId],
        ),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);

  @override
  _i4.Future<void> disconnect(String? deviceId) => (super.noSuchMethod(
        Invocation.method(
          #disconnect,
          [deviceId],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Stream<_i6.ConnectionState> connectionStateStream(String? deviceId) =>
      (super.noSuchMethod(
        Invocation.method(
          #connectionStateStream,
          [deviceId],
        ),
        returnValue: _i4.Stream<_i6.ConnectionState>.empty(),
      ) as _i4.Stream<_i6.ConnectionState>);

  @override
  _i4.Future<List<_i5.BluetoothDeviceModel>> getSystemConnectedDevices() =>
      (super.noSuchMethod(
        Invocation.method(
          #getSystemConnectedDevices,
          [],
        ),
        returnValue: _i4.Future<List<_i5.BluetoothDeviceModel>>.value(
            <_i5.BluetoothDeviceModel>[]),
      ) as _i4.Future<List<_i5.BluetoothDeviceModel>>);

  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [StoredDeviceHandler].
///
/// See the documentation for Mockito's code generation for more information.
class MockStoredDeviceHandler extends _i1.Mock
    implements _i7.StoredDeviceHandler {
  MockStoredDeviceHandler() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.Isar get database => (super.noSuchMethod(
        Invocation.getter(#database),
        returnValue: _FakeIsar_0(
          this,
          Invocation.getter(#database),
        ),
      ) as _i2.Isar);

  @override
  _i4.Future<List<_i8.StoredDevice>> getAllDevices() => (super.noSuchMethod(
        Invocation.method(
          #getAllDevices,
          [],
        ),
        returnValue:
            _i4.Future<List<_i8.StoredDevice>>.value(<_i8.StoredDevice>[]),
      ) as _i4.Future<List<_i8.StoredDevice>>);

  @override
  _i4.Future<_i8.StoredDevice?> getDeviceById(String? deviceId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getDeviceById,
          [deviceId],
        ),
        returnValue: _i4.Future<_i8.StoredDevice?>.value(),
      ) as _i4.Future<_i8.StoredDevice?>);

  @override
  _i4.Future<void> saveDevice(_i8.StoredDevice? device) => (super.noSuchMethod(
        Invocation.method(
          #saveDevice,
          [device],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> removeDevice(String? deviceId) => (super.noSuchMethod(
        Invocation.method(
          #removeDevice,
          [deviceId],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> updateLastConnected(String? deviceId) => (super.noSuchMethod(
        Invocation.method(
          #updateLastConnected,
          [deviceId],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> clear() => (super.noSuchMethod(
        Invocation.method(
          #clear,
          [],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
}
