class Device {
  final int id;
  final String name;
  final String description;
  final double price;
  final String image;

  String status;
  int temperature;
  int battery;

  Device({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.status,
    required this.temperature,
    required this.battery,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'],
      name: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      image: json['thumbnail'] ?? '',
      status: 'Stopped',
      temperature: 40,
      battery: 80,
    );
  }
}