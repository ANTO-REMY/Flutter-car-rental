import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ManageBookingsScreen extends StatefulWidget {
  const ManageBookingsScreen({super.key});

  @override
  _ManageBookingsScreenState createState() => _ManageBookingsScreenState();
}

class _ManageBookingsScreenState extends State<ManageBookingsScreen> {
  List<Map<String, dynamic>> bookings = [];

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    try {
      final response = await http.get(
        Uri.parse('http://tujengeane.co.ke/booking_operations.php'),
      );
      
      if (response.statusCode == 200) {
        setState(() {
          bookings = List<Map<String, dynamic>>.from(jsonDecode(response.body));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching bookings: $e')),
      );
    }
  }

  Future<void> deleteBooking(int bookingId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://tujengeane.co.ke/booking_operations.php?id=$bookingId'),
      );
      
      final result = jsonDecode(response.body);
      if (result['status'] == 'success') {
        await fetchBookings();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking deleted successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting booking: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(30, 30, 30, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(30, 30, 30, 1),
        title: const Text('Manage Bookings'),
      ),
      body: ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return Card(
            color: const Color.fromRGBO(62, 62, 61, 1),
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(
                booking['car_name'],
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dates: ${booking['start_date']} to ${booking['end_date']}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(
                    'Total: Ksh ${booking['total_price']}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(
                    'Status: ${booking['status']}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => deleteBooking(booking['booking_id']),
              ),
            ),
          );
        },
      ),
    );
  }
} 