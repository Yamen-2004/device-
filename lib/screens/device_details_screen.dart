import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/device_controller.dart';
import '../models/device.dart';

class DeviceDetailsScreen extends StatelessWidget {
  final Device device;

  const DeviceDetailsScreen({
    super.key,
    required this.device,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DeviceController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                device.image,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              device.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              device.description,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Price: \$${device.price}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Obx(() {
              return DeviceStatusSection(
                device: device,
                controller: controller,
              );
            }),
          ],
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