import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/device_controller.dart';
import 'services/device_service.dart';
import 'screens/home_screen.dart';

void main() {
  final dio = Dio();

  final service = DeviceService(dio);

  Get.put(
    DeviceController(service),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Device Monitor',
      home: const HomeScreen(),
    );
  }
}