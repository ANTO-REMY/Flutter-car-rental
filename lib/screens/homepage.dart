import 'package:flutter/material.dart';
import 'package:flutter_cat1/controllers/car_widget.dart';
import 'package:flutter_cat1/screens/booking.dart';
import 'package:flutter_cat1/screens/login.dart';
import 'package:flutter_cat1/screens/settings.dart';
import 'package:get/get.dart';
import 'package:flutter_cat1/screens/cardata.dart';
import 'package:flutter_cat1/screens/profile.dart';
import 'package:flutter_cat1/screens/favorites.dart';
import 'package:flutter_cat1/screens/order_history.dart';

class DashboardController extends GetxController {
  RxInt selectedMenu = 0.obs;

  void updateSelected(int i) {
    selectedMenu.value = i;
  }
}

final DashboardController dashboardController = Get.put(DashboardController());

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required email, required password});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<List<Car>> futureCars;
  List<Car> filteredCarList = [];
  final TextEditingController searchController = TextEditingController();
  final Map<String, bool> selectedFuelTypes = {
    'Petrol': false,
    'Diesel': false,
  };
  final Map<String, bool> priceRanges = {
    '0 - 3000': false,
    '3500 - 10000': false,
    '10000 - 20000': false,
  };
  final List<String> carBrands = [
    'Toyota', 'Mazda', 'BMW', 'Nissan', 'Audi', 'Land Cruiser', 'Limousine', 'Mercedes Benz'
  ];

  // Map of car names to local image paths
  final Map<String, String> carImages = {
    'Landrover': 'assets/images/range rear 1.webp',
    'audi': 'assets/images/audi side.jpeg',
    'Mercedes Benz': 'assets/images/mercedes front 2.jpeg',
    'Toyota': 'assets/images/toyota axio front.webp',
    'Mazda CX-5': 'assets/images/mazda cx 5 front.webp',
    'Mazda Axela': 'assets/images/mazda axela.png', 
    'Limousine': 'assets/images/Lincoln-Stretch-Limousine.png',
    'Mazda Demio': 'assets/images/mazda demio.jpeg',
    'Land cruizer V8': 'assets/images/land cruizer front 2.webp',
    'Land cruizer': 'assets/images/land cruizer front.jpg'
  };

  String selectedBrand = '';

  @override
  void initState() {
    super.initState();
    futureCars = fetchCars();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final cars = await fetchCars();
      setState(() {
        filteredCarList = cars;
      });
    } catch (e) {
      print('Error loading initial data: $e'); // Debug print
    }
  }

  Future<void> _refreshCars() async {
    setState(() {
      futureCars = fetchCars();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterCars() {
    if (filteredCarList.isEmpty) return;
    
    String query = searchController.text.toLowerCase();
    futureCars.then((cars) {
      setState(() {
        filteredCarList = cars.where((car) {
          bool matchesQuery = car.carname.toLowerCase().contains(query) ||
              car.description.toLowerCase().contains(query);
          bool matchesFuel = selectedFuelTypes.entries.every((entry) =>
              entry.value == false || car.fuel == entry.key);
          bool matchesPrice = priceRanges.entries.every((entry) {
            if (!entry.value) return true;
            if (entry.key == '0 - 3000') {
              return car.price <= 3000;
            } else if (entry.key == '3500 - 10000') {
              return car.price > 3500 && car.price <= 10000;
            } else if (entry.key == '10000 - 20000') {
              return car.price > 10000;
            }
            return false;
          });

          return matchesQuery && matchesFuel && matchesPrice;
        }).toList();
      });
    });
  }

  

  void _togglePriceRange(String range) {
    setState(() {
      priceRanges[range] = !priceRanges[range]!;
      _filterCars();
    });
  }

  void _selectBrand(String brand) {
    setState(() {
      selectedBrand = (selectedBrand == brand) ? '' : brand;
      _filterCars();
    });
  }

  void _showActionMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.35,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(30, 30, 30, 1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.settings,
                    color: Colors.blue,
                    size: 28,
                  ),
                ),
                title: const Text(
                  'Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsScreen()),
                  );
                },
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.history,
                    color: Colors.green,
                    size: 28,
                  ),
                ),
                title: const Text(
                  'Order History',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OrderHistoryScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String _getCarImagePath(String carName) {
    // Try to find an exact match first
    if (carImages.containsKey(carName)) {
      return carImages[carName]!;
    }

    // If no exact match, try case-insensitive match
    String normalizedName = carName.toLowerCase();
    for (var entry in carImages.entries) {
      if (entry.key.toLowerCase() == normalizedName) {
        return entry.value;
      }
    }

    // Return default image if no match found
    return 'assets/images/default_car.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(30, 30, 30, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(30, 30, 30, 1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen(email: '', password: '',)),
            );
          },
        ),
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Remy Car Rentals',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Row(
        children: [
          // Filters Section
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            padding: const EdgeInsets.all(16.0),
            color: const Color.fromRGBO(40, 40, 40, 1),
            child: ListView(
              children: [
                const Text(
                  'Filters',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Fuel Type',
                  style: TextStyle(color: Colors.white),
                ),
                for (String type in selectedFuelTypes.keys)
                  CheckboxListTile(
                    value: selectedFuelTypes[type],
                    title: Text(type, style: const TextStyle(color: Colors.white)),
                    onChanged: (_) => setState(() {
                      selectedFuelTypes[type] = !selectedFuelTypes[type]!;
                      _filterCars();
                    }),
                    activeColor: Colors.blue,
                  ),
                const SizedBox(height: 16),
                const Text(
                  'Price Range',
                  style: TextStyle(color: Colors.white),
                ),
                for (String range in priceRanges.keys)
                  CheckboxListTile(
                    value: priceRanges[range],
                    title: Text(range, style: const TextStyle(color: Colors.white)),
                    onChanged: (_) => setState(() {
                      priceRanges[range] = !priceRanges[range]!;
                      _filterCars();
                    }),
                    activeColor: Colors.blue,
                  ),
              ],
            ),
          ),
          // Main Section
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          prefixIcon: const Icon(Icons.search, color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: const Color.fromRGBO(50, 50, 50, 1),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: carBrands.map((brand) {
                            bool isSelected = selectedBrand == brand;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: GestureDetector(
                                onTap: () => _selectBrand(brand),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 16.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color.fromARGB(255, 150, 190, 222)
                                        : const Color.fromRGBO(50, 50, 50, 1),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Text(
                                    brand,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<Car>>(
                    future: futureCars,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        print('Error in FutureBuilder: ${snapshot.error}'); // Debug print
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 60,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Error: ${snapshot.error}',
                                style: const TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _refreshCars,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text(
                            'No cars available',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      final displayCars = filteredCarList.isEmpty ? snapshot.data! : filteredCarList;

                      return GridView.builder(
                        padding: const EdgeInsets.all(8),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 0.70,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: displayCars.length,
                        itemBuilder: (context, index) {
                          final car = displayCars[index];
                          return CarWidget(
                            car: car,
                            onTap: () {},
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: dashboardController.selectedMenu.value,
          onTap: (index) {
            if (index == 1) {
              _showActionMenu(context);
            } else {
              dashboardController.updateSelected(index);
            }
          },
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.directions_car),
              label: 'Action',
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                icon: const Icon(Icons.favorite),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FavoritesScreen()),
                  );
                },
              ),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen(userEmail: '',)),
                  );
                },
              ),
              label: 'Profile',
            ),
          ],
          backgroundColor: const Color.fromRGBO(62, 62, 61, 1),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          unselectedItemColor: const Color.fromRGBO(200, 200, 200, 1),
          showUnselectedLabels: true,
          showSelectedLabels: true,
        ),
      ),
    );
  }
}

