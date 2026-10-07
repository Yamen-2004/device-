import 'package:dio/dio.dart';
import '../models/device.dart';

class DeviceService {
  final Dio dio;

  DeviceService(this.dio);

  Future<List<Device>> getDevices() async {
    final response = await dio.get(
      'https://dummyjson.com/products',
    );

    final List products = response.data['products'];

    return products
        .map(
          (json) => Device.fromJson(json),
        )
        .toList();
  }
}