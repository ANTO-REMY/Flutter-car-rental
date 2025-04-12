import 'package:http/http.dart' as http;
import 'dart:convert';

class Car {
  final String id;
  final String carname;
  final String model;
  final String description;
  final double price;
  final String fuel;
  bool isFavorite;

  Car({
    required this.id,
    required this.carname,
    required this.model,
    required this.description,
    required this.price,
    required this.fuel,
    this.isFavorite = false,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id']?.toString() ?? '',
      carname: json['carname'] ?? '',
      model: json['model'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      fuel: json['fuel'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'carname': carname,
      'model': model,
      'description': description,
      'price': price,
      'fuel': fuel,
      'isFavorite': isFavorite,
    };
  }
}

Future<List<Car>> fetchCars() async {
  try {
    final response = await http.get(
      Uri.parse('https://tujengeane.co.ke/CarRental/getCars.php'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      
      if (data['status'] == 'success' && data['cars'] is List) {
        return (data['cars'] as List)
            .map((carJson) => Car.fromJson(carJson))
            .toList();
      } else {
        throw Exception(data['message'] ?? 'Failed to load cars');
      }
    } else {
      throw Exception('Failed to load cars: HTTP ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to load cars: $e');
  }
}