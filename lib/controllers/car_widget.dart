import 'package:flutter/material.dart';
import 'package:flutter_cat1/screens/cardata.dart';
import 'package:get/get.dart';
import 'package:flutter_cat1/screens/favorites_manager.dart';
import 'package:flutter_cat1/screens/booking.dart';

class CarWidget extends StatefulWidget {
  final Car car;
  const CarWidget({super.key, required this.car, required Null Function() onTap});

  @override
  _CarWidgetState createState() => _CarWidgetState();
}

class _CarWidgetState extends State<CarWidget> {
  final FavoritesManager favoritesManager = Get.put(FavoritesManager());

  Widget _buildImage() {
    try {
      final imagePath = _getCarImagePath(widget.car.carname);
      print('Loading image for ${widget.car.carname}: $imagePath');

      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          imagePath,
          height: 120,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print('Error loading image: $error for ${widget.car.carname}');
            return Container(
              height: 120,
              color: Colors.grey[300],
              child: const Icon(Icons.error),
            );
          },
        ),
      );
    } catch (e) {
      print('Error in _buildImage for ${widget.car.carname}: $e');
      return Container(
        height: 120,
        color: Colors.grey[300],
        child: const Icon(Icons.error),
      );
    }
  }

  String _getCarImagePath(String carName) {
    final Map<String, List<String>> carImageMapping = {
      'range rear 1.png': ['land rover', 'landrover', 'range rover'],
      'mercedes front 2.jpeg': ['mercedes', 'Mercedes Benz', 'mercedes-benz'],
      'mazda cx 5 front.webp': ['mazda cx5', 'mazda CX-5', 'cx5', 'cx-5'],
      'mazda axela.png': ['mazda axela', 'axela'],
      'Lincoln-Stretch-Limousine.png': ['limousine', 'lincoln', 'stretch'],
      'mazda demio.jpeg': ['mazda demio', 'demio'],
      'land cruizer front 2.webp': ['land cruiser v8', 'land cruizer v8', 'v8'],
      'land cruizer front.jpg': ['land cruiser', 'land cruizer'],
      'toyota axio front.webp': ['toyota', 'toyota axio', 'axio'],
      'audi side.jpeg': ['audi', 'audi a4']
    };

    final normalizedInput = carName.toLowerCase().trim();

    for (var entry in carImageMapping.entries) {
      if (entry.value.any((variant) => normalizedInput.contains(variant))) {
        return 'assets/images/${entry.key}';
      }
    }

    print('No image match found for: $carName');
    return 'assets/images/default_car.png';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(62, 62, 61, 1),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.car.carname,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: _buildImage(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.car.description,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.local_gas_station, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      widget.car.fuel,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                IconButton(
                  icon: Icon(
                    widget.car.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: widget.car.isFavorite ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      favoritesManager.toggleFavorite(widget.car);
                    });
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Ksh ${widget.car.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingScreen(
                              car: widget.car,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 120, 170, 255),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Book Now',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
