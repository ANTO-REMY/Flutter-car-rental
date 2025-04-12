import 'package:flutter/material.dart';
import 'package:flutter_cat1/screens/cardata.dart';

class OrderHistoryScreen extends StatelessWidget {
  final Car? bookedCar;

  const OrderHistoryScreen({
    super.key,
    this.bookedCar,
  });

  String _getCarImagePath(String carName) {
    final Map<String, String> carImages = {
      'Land Rover': 'range rear 1.webp',
      'Mercedes Benz': 'mercedes front 2.png',
      'Mazda CX-5': 'mazda cx 5 front.webp',
      'Mazda Axela': 'mazda axela.png',
      'Limousine': 'Lincoln-Stretch-Limousine.png',
      'Mazda Demio': 'mazda demio.jpeg',
      'Land Cruiser V8': 'land cruizer front 2.webp',
      'Land Cruiser 2023': 'land cruizer front.jpg',
      'Toyota': 'toyota axio front.webp',
      'Audi': 'audi side.jpeg'
    };

    String normalize(String input) {
      return input.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    }

    final normalizedInput = normalize(carName);
    
    for (var entry in carImages.entries) {
      if (normalizedInput.contains(normalize(entry.key))) {
        return 'assets/images/${entry.value}';
      }
    }

    return 'assets/images/default_car.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(30, 30, 30, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(30, 30, 30, 1),
        title: const Text('Order History', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: bookedCar == null
                ? const Center(
                    child: Text(
                      'No orders yet',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  )
                : Card(
                    color: const Color.fromRGBO(62, 62, 61, 1),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              _getCarImagePath(bookedCar!.carname),
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            bookedCar!.carname,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            bookedCar!.description,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Ksh ${bookedCar!.price.toStringAsFixed(2)} per day',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Fuel Type: ${bookedCar!.fuel}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
} 