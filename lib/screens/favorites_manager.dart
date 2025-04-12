import 'package:get/get.dart';
import 'package:flutter_cat1/screens/cardata.dart';

class FavoritesManager extends GetxController {
  final RxList<Car> _favorites = <Car>[].obs;

  List<Car> get favorites => _favorites.toList();

  void toggleFavorite(Car car) {
    car.isFavorite = !car.isFavorite;
    if (car.isFavorite) {
      _favorites.add(car);
    } else {
      _favorites.removeWhere((favCar) => favCar.id == car.id);
    }
    update();
  }
}