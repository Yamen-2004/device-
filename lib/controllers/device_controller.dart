import 'package:get/get.dart';

import '../models/device.dart';
import '../services/device_service.dart';

class DeviceController extends GetxController {
  final DeviceService service;

  DeviceController(this.service);

  final RxList<Device> devices = <Device>[].obs;

  final RxBool isLoading = false.obs;

  final RxString errorMessage = ''.obs;

  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDevices();
  }

  Future<void> fetchDevices() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await service.getDevices();

      devices.assignAll(result);
    } catch (e) {
      errorMessage.value = 'Something went wrong';
    } finally {
      isLoading.value = false;
    }
  }

  List<Device> get filteredDevices {
    if (searchQuery.value.isEmpty) {
      return devices;
    }

    return devices.where((device) {
      return device.name
          .toLowerCase()
          .contains(searchQuery.value.toLowerCase());
    }).toList();
  }

  void search(String value) {
    searchQuery.value = value;
  }

  void startDevice(Device device) {
    device.status = 'Running';
    devices.refresh();
  }

  void stopDevice(Device device) {
    device.status = 'Stopped';
    devices.refresh();
  }
}