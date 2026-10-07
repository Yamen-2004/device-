import 'package:devices_project/models/device.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/device_controller.dart';
import 'device_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DeviceController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Devices'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: controller.search,
              decoration: InputDecoration(
                hintText: 'Search devices...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (controller.errorMessage.value.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        controller.errorMessage.value,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: controller.fetchDevices,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              final devices = controller.filteredDevices;

              if (devices.isEmpty) {
                return const Center(
                  child: Text(
                    'No devices found.',
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  final device = devices[index];

                  return DeviceCard(
                    device: device,
                    onTap: () {
                      Get.to(
                        () => DeviceDetailsScreen(
                          device: device,
                        ),
                      );
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}



class DeviceCard extends StatelessWidget {
  final Device device;
  final VoidCallback onTap;

  const DeviceCard({
    super.key,
    required this.device,
    required this.onTap,
  });

  Color get statusColor {
    switch (device.status) {
      case 'Running':
        return Colors.green;
      case 'Stopped':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  device.image,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey.shade300,
                      child: const Icon(
                        Icons.devices,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      device.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        CircleAvatar(
                          radius: 5,
                          backgroundColor: statusColor,
                        ),
                        const SizedBox(width: 6),
                        Text(device.status),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'Temperature: ${device.temperature}°C',
                    ),

                    Text(
                      'Battery: ${device.battery}%',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class DeviceStatusSection extends StatelessWidget {
  final Device device;
  final DeviceController controller;

  const DeviceStatusSection({
    super.key,
    required this.device,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isRunning = device.status == 'Running';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Status: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              device.status,
              style: TextStyle(
                color: isRunning
                    ? Colors.green
                    : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Text(
          'Temperature: ${device.temperature}°C',
        ),

        const SizedBox(height: 8),

        Text(
          'Battery: ${device.battery}%',
        ),

        const SizedBox(height: 24),

        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  controller.startDevice(device);
                },
                child: const Text('START'),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  controller.stopDevice(device);
                },
                child: const Text('STOP'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}