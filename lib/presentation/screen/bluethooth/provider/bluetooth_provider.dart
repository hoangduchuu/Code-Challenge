import 'package:code_challenge/domain/bluetooth_repository.dart';
import 'package:code_challenge/service/bluetooth/model/bluetooth_device_model.dart';
import 'package:flutter/foundation.dart';

class BluetoothProvider extends ChangeNotifier {
  final BluetoothRepository _repository;

  bool _isEnabled = false;
  bool _isScanning = false;
  List<BluetoothDeviceModel> _discoveredDevices = [];

  BluetoothProvider(this._repository) {
    _init();
  }

  // Getters
  bool get isEnabled => _isEnabled;

  bool get isScanning => _isScanning;

  List<BluetoothDeviceModel> get discoveredDevices => _discoveredDevices;

  Future<void> _init() async {
    try {
      // Initialize bluetooth
      await _repository.initialize();

      // Listen to bluetooth state
      _repository.isEnabled.listen((enabled) {
        _isEnabled = enabled;
        notifyListeners();
      });

      // Listen to discovered devices
      _repository.discoveredDevices.listen((devices) {
        _discoveredDevices = devices;
        notifyListeners();
      });
    } catch (e) {
      debugPrint('Error initializing bluetooth: $e');
    }
  }

  Future<void> startScan() async {
    if (_isScanning) return;

    _isScanning = true;
    notifyListeners();

    try {
      await _repository.startScan();
    } catch (e) {
      debugPrint('Error starting scan: $e');
    } finally {
      _isScanning = false;
      notifyListeners();
    }
  }

  Future<void> stopScan() async {
    try {
      await _repository.stopScan();
      _isScanning = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error stopping scan: $e');
    }
  }

  Future<void> enableBluetooth() async {
    try {
      await _repository.enableBluetooth();
    } catch (e) {
      debugPrint('Error enabling bluetooth: $e');
    }
  }

  Future<void> connect(String deviceId) async {
    try {
      await _repository.connect(deviceId);
    } catch (e) {
      debugPrint('Error connecting to device: $e');
    }
  }

  Future<void> disconnect(String deviceId) async {
    try {
      await _repository.disconnect(deviceId);
    } catch (e) {
      debugPrint('Error disconnecting from device: $e');
    }
  }

  @override
  void dispose() {
    _repository.dispose();
    super.dispose();
  }
}
