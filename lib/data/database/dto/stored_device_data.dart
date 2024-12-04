import 'package:code_challenge/service/bluetooth/model/bluetooth_device_model.dart';
import 'package:isar/isar.dart';

part 'stored_device_data.g.dart';

@collection
class StoredDevice {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String deviceId;

  late String name;
  late DateTime lastConnected;

  StoredDevice({
    required this.deviceId,
    required this.name,
    required this.lastConnected,
  });

  factory StoredDevice.fromBluetoothDevice(BluetoothDeviceModel device) {
    return StoredDevice(
      deviceId: device.id,
      name: device.name,
      lastConnected: DateTime.now(),
    );
  }
}
