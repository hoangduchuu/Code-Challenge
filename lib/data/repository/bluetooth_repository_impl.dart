import 'package:code_challenge/domain/bluetooth_repository.dart';
import 'package:code_challenge/service/bluetooth/bluetooth_interface.dart';
import 'package:code_challenge/service/bluetooth/model/bluetooth_device_model.dart';
import 'package:code_challenge/service/bluetooth/model/connection_state.dart';

class BluetoothRepositoryImpl implements BluetoothRepository {
  final IBluetoothInterface _bluetooth;

  // final Isar _isar;

  BluetoothRepositoryImpl(this._bluetooth);

  @override
  Future<bool> initialize() => _bluetooth.initialize();

  @override
  Future<bool> enableBluetooth() => _bluetooth.enableBluetooth();

  @override
  Future<bool> disableBluetooth() => _bluetooth.disableBluetooth();

  @override
  Stream<bool> get isEnabled => _bluetooth.isEnabled();

  @override
  Future<void> startScan() => _bluetooth.startScan();

  @override
  Future<void> stopScan() => _bluetooth.stopScan();

  @override
  Stream<List<BluetoothDeviceModel>> get discoveredDevices => _bluetooth.discoveredDevices();

  @override
  Future<bool> connect(String deviceId) => _bluetooth.connect(deviceId);

  @override
  Future<void> disconnect(String deviceId) => _bluetooth.disconnect(deviceId);

  @override
  Stream<ConnectionState> connectionStateStream(String deviceId) => _bluetooth.connectionStateStream(deviceId);

  @override
  void dispose() {
    _bluetooth.dispose();
  }
}
