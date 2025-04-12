import 'package:flutter/material.dart';
import 'package:flutter_cat1/screens/cardata.dart';
import 'package:flutter_cat1/screens/order.dart';

class BookingScreen extends StatefulWidget {
  final Car car;
  const BookingScreen({super.key, required this.car});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? pickupDate;
  DateTime? returnDate;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

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

  double calculateTotalPrice() {
    if (pickupDate == null || returnDate == null) return 0;
    
    final difference = returnDate!.difference(pickupDate!).inDays;
    return widget.car.price * difference;
  }

  Future<void> saveBooking() async {
    if (pickupDate == null || returnDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both pickup and return dates')),
      );
      return;
    }

    if (_nameController.text.isEmpty || 
        _phoneController.text.isEmpty || 
        _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderScreen(
          customerName: _nameController.text,
          customerPhone: _phoneController.text,
          customerEmail: _emailController.text,
          totalAmount: calculateTotalPrice(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(30, 30, 30, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(30, 30, 30, 1),
        title: const Text('Book a Car', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Car Details Card
                Expanded(
                  flex: 1,
                  child: Card(
                    color: const Color.fromRGBO(62, 62, 61, 1),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              _getCarImagePath(widget.car.carname),
                              fit: BoxFit.contain,
                              height: 200,
                              width: double.infinity,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            widget.car.carname,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.car.description,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Ksh ${widget.car.price.toStringAsFixed(2)} per day',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Booking Form Card
                Expanded(
                  flex: 1,
                  child: Card(
                    color: const Color.fromRGBO(62, 62, 61, 1),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Booking Details',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _nameController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Full Name',
                              labelStyle: const TextStyle(color: Colors.white70),
                              filled: true,
                              fillColor: Colors.grey[800],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _phoneController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              labelStyle: const TextStyle(color: Colors.white70),
                              filled: true,
                              fillColor: Colors.grey[800],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _emailController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: const TextStyle(color: Colors.white70),
                              filled: true,
                              fillColor: Colors.grey[800],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: const Text(
                                    'Pickup Date',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    pickupDate?.toString().split(' ')[0] ?? 'Select Date',
                                    style: const TextStyle(color: Colors.white70),
                                  ),
                                  onTap: () async {
                                    final date = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now().add(const Duration(days: 365)),
                                    );
                                    if (date != null) {
                                      setState(() => pickupDate = date);
                                    }
                                  },
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: const Text(
                                    'Return Date',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    returnDate?.toString().split(' ')[0] ?? 'Select Date',
                                    style: const TextStyle(color: Colors.white70),
                                  ),
                                  onTap: () async {
                                    final date = await showDatePicker(
                                      context: context,
                                      initialDate: pickupDate ?? DateTime.now(),
                                      firstDate: pickupDate ?? DateTime.now(),
                                      lastDate: DateTime.now().add(const Duration(days: 365)),
                                    );
                                    if (date != null) {
                                      setState(() => returnDate = date);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                child: Text(
                                  'Total Price: Ksh ${calculateTotalPrice().toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: saveBooking,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 120, 170, 255),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Confirm Booking',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

