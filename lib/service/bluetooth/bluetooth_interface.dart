import 'package:code_challenge/service/bluetooth/model/bluetooth_device_model.dart';
import 'package:code_challenge/service/bluetooth/model/connection_state.dart';

abstract class IBluetoothInterface {
  Future<bool> initialize();

  Future<bool> enableBluetooth();

  Future<bool> disableBluetooth();

  Stream<bool> isEnabled();

  Future<void> startScan();

  Future<void> stopScan();

  Stream<List<BluetoothDeviceModel>> discoveredDevices();

  Future<bool> connect(String deviceId);

  Future<void> disconnect(String deviceId);

  Stream<ConnectionState> connectionStateStream(String deviceId);

  Future<List<BluetoothDeviceModel>> getSystemConnectedDevices();

  void dispose();
}
