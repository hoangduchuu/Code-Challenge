import 'package:code_challenge/data/database/dto/stored_device_data.dart';
import 'package:isar/isar.dart';

class StoredDeviceHandler {
  final Isar database;

  StoredDeviceHandler(this.database);

  Future<List<StoredDevice>> getAllDevices() async {
    return await database.storedDevices.where().sortByLastConnectedDesc().findAll();
  }

  Future<StoredDevice?> getDeviceById(String deviceId) async {
    return await database.storedDevices.getByDeviceId(deviceId);
  }

  Future<void> saveDevice(StoredDevice device) async {
    await database.writeTxn(() async {
      await database.storedDevices.putByDeviceId(device);
    });
  }

  Future<void> removeDevice(String deviceId) async {
    await database.writeTxn(() async {
      await database.storedDevices.deleteByDeviceId(deviceId);
    });
  }

  Future<void> updateLastConnected(String deviceId) async {
    await database.writeTxn(() async {
      final device = await getDeviceById(deviceId);
      if (device != null) {
        final updatedDevice = StoredDevice(
          deviceId: device.deviceId,
          name: device.name,
          lastConnected: DateTime.now(),
        );
        updatedDevice.id = device.id;
        await database.storedDevices.put(updatedDevice);
      }
    });
  }

  Future<void> clear() async {
    await database.writeTxn(() async {
      await database.storedDevices.clear();
    });
  }
}
