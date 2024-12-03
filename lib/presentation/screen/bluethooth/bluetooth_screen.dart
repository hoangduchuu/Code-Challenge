import 'package:code_challenge/core/di/service_locator.dart';
import 'package:code_challenge/presentation/screen/bluethooth/provider/bluetooth_provider.dart';
import 'package:code_challenge/service/bluetooth/model/bluetooth_device_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BluetoothScreen extends StatelessWidget {
  const BluetoothScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BluetoothProvider>(
      create: (_) => locator<BluetoothProvider>(),
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Bluetooth'),
          actions: [
            Switch(
              value: context.watch<BluetoothProvider>().isEnabled,
              onChanged: (value) {
                if (value) {
                  context.read<BluetoothProvider>().enableBluetooth();
                }
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () => context.read<BluetoothProvider>().startScan(),
          child: CustomScrollView(
            slivers: [
              if (context.watch<BluetoothProvider>().isScanning)
                const SliverToBoxAdapter(
                  child: LinearProgressIndicator(),
                ),
              const SliverToBoxAdapter(
                child: BluetoothHeader(),
              ),
              const SliverToBoxAdapter(
                child: DiscoveredDevicesList(),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.read<BluetoothProvider>().startScan(),
          child: const Icon(Icons.bluetooth_searching),
        ),
      ),
    );
  }
}

class BluetoothHeader extends StatelessWidget {
  const BluetoothHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BluetoothProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Bluetooth Status',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: provider.isEnabled ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      provider.isEnabled ? 'Enabled' : 'Disabled',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (provider.isScanning)
                const Text('Scanning for devices...')
              else
                Text(
                  'Found ${provider.discoveredDevices.length} devices',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
            ],
          ),
        );
      },
    );
  }
}

class DiscoveredDevicesList extends StatelessWidget {
  const DiscoveredDevicesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BluetoothProvider>(
      builder: (context, provider, _) {
        final devices = provider.discoveredDevices;

        if (devices.isEmpty && !provider.isScanning) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('No devices found. Pull to scan for devices.'),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: devices.length,
          itemBuilder: (context, index) => DeviceListTile(device: devices[index]),
        );
      },
    );
  }
}

class DeviceListTile extends StatelessWidget {
  final BluetoothDeviceModel device;

  const DeviceListTile({
    super.key,
    required this.device,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.read<BluetoothProvider>();

    return ListTile(
      leading: const Icon(Icons.bluetooth),
      title: Text(device.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ID: ${device.id}'),
          Text('Signal Strength: ${device.rssi} dBm'),
          Text(
            'Connect status ${device.isConnected}',
            style: TextStyle(
              color: device.isConnected ? Colors.green : Colors.red,
              fontSize: device.isConnected ? 20 : 14,
            ),
          ),
        ],
      ),
      trailing: device.isConnected
          ? IconButton(
              icon: const Icon(Icons.link_off),
              onPressed: () => provider.disconnect(device.id),
            )
          : ElevatedButton(
              onPressed: () => provider.connect(device.id),
              child: const Text('Connect'),
            ),
    );
  }
}
