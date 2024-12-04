import 'package:code_challenge/service/bluetooth/model/bluetooth_device_model.dart';

class BluetoothDeviceFilter {
  // ignore: constant_identifier_names
  static const int MIN_RSSI = -90; // Minimum signal strength
  static const int MIN_NAME_LENGTH = 1;

  static List<BluetoothDeviceModel> filterDevices(List<BluetoothDeviceModel> devices) {
    // First filter out invalid devices
    final validDevices = devices.where(isValidDevice).toList();

    // Then sort the remaining devices
    validDevices.sort((a, b) {
      // 1. Sort by connection status first
      if (a.isConnected != b.isConnected) {
        return b.isConnected ? 1 : -1; // Connected devices first
      }

      // 2. Sort by name
      final nameCompare = a.name.toLowerCase().compareTo(b.name.toLowerCase());
      if (nameCompare != 0) {
        return nameCompare;
      }

      // 3. If names are equal, sort by signal strength
      return b.rssi.compareTo(a.rssi);
    });

    return validDevices;
  }

  static bool isValidDevice(BluetoothDeviceModel device) {
    return _hasValidName(device.name) &&
        _hasGoodSignal(device.rssi);
  }

  static bool _hasValidName(String name) {
    if (name.isEmpty || name.length < MIN_NAME_LENGTH) return false;
    if (name == 'Unknown Device') return false;
    if (name.trim().isEmpty) return false;
    // Add more name validation if needed
    return true;
  }

  static bool _hasGoodSignal(int rssi) {
    return rssi >= MIN_RSSI;
  }
}