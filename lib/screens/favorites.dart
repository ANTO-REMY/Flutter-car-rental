import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_cat1/controllers/car_widget.dart';
import 'package:flutter_cat1/screens/favorites_manager.dart';

class FavoritesScreen extends StatelessWidget {
  final FavoritesManager favoritesManager = Get.find<FavoritesManager>();

  FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 55, 55, 55),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(30, 30, 30, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // This will navigate back to the previous screen
          },
        ),
        title: const Text(
          'Favorites',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: GetBuilder<FavoritesManager>(
        builder: (controller) {
          final favorites = controller.favorites;
          
          if (favorites.isEmpty) {
            return const Center(
              child: Text(
                'No favorites yet',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.70,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              return CarWidget(car: favorites[index], onTap: () {  },);
            },
          );
        },
      ),
    );
  }
}