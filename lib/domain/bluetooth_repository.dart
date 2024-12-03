import 'package:code_challenge/service/bluetooth/model/bluetooth_device_model.dart';
import 'package:code_challenge/service/bluetooth/model/connection_state.dart';

abstract class BluetoothRepository {
  Future<bool> initialize();

  Future<bool> enableBluetooth();

  Future<bool> disableBluetooth();

  Stream<bool> get isEnabled;

  Future<void> startScan();

  Future<void> stopScan();

  Stream<List<BluetoothDeviceModel>> get discoveredDevices;

  Future<bool> connect(String deviceId);

  Future<void> disconnect(String deviceId);

  Stream<ConnectionState> connectionStateStream(String deviceId);

  // Future<List<StoredDevice>> getStoredDevices();

  // Future<void> saveDevice(StoredDevice device);

  // Future<void> removeDevice(String deviceId);
}
