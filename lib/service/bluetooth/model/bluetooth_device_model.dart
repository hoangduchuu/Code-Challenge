// lib/features/bluetooth/domain/models/bluetooth_device_model.dart

class BluetoothDeviceModel {
  final String id;
  final String name;
  final bool isConnected;
  final DateTime lastConnected;
  final int rssi;

  BluetoothDeviceModel({
    required this.id,
    required this.name,
    required this.isConnected,
    required this.lastConnected,
    required this.rssi,
  });

  factory BluetoothDeviceModel.fromDevice(
    dynamic device, {
    bool isConnected = false,
    int rssi = 0,
  }) {
    return BluetoothDeviceModel(
      id: device.remoteId.str,
      name: device.platformName.isEmpty ? '' : device.platformName,
      isConnected: isConnected,
      lastConnected: DateTime.now(),
      rssi: rssi,
    );
  }

  BluetoothDeviceModel copyWith({
    String? id,
    String? name,
    bool? isConnected,
    DateTime? lastConnected,
    int? rssi,
  }) {
    return BluetoothDeviceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isConnected: isConnected ?? this.isConnected,
      lastConnected: lastConnected ?? this.lastConnected,
      rssi: rssi ?? this.rssi,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is BluetoothDeviceModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'BluetoothDeviceModel{id: $id, name: $name, isConnected: $isConnected, lastConnected: $lastConnected, rssi: $rssi}';
  }
}
