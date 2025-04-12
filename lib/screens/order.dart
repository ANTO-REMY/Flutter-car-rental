import 'package:flutter/material.dart';
import 'package:flutter_cat1/screens/cardata.dart';
import 'package:intl/intl.dart';

class OrderScreen extends StatefulWidget {
  final Car? car;
  final int? bookingId;
  final String? customerName;
  final String? customerPhone;
  final String? customerEmail;
  final DateTime? pickupDate;
  final DateTime? returnDate;
  final double? totalAmount;
  
  const OrderScreen({
    super.key, 
    this.car, 
    this.bookingId,
    this.customerName,
    this.customerPhone,
    this.customerEmail,
    this.pickupDate,
    this.returnDate,
    this.totalAmount,
  });

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String selectedPaymentMethod = 'MPESA';
  bool isLoading = false;
  String orderStatus = 'PENDING';
  String? orderCreatedAt;
  final TextEditingController mpesaNumberController = TextEditingController();
  bool showConfirmation = false;
  Map<String, dynamic> orderDetails = {};

  void confirmOrder() {
    if (selectedPaymentMethod == 'MPESA' && mpesaNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter M-PESA number')),
      );
      return;
    }

    setState(() {
      isLoading = true;
      orderStatus = 'CONFIRMED';
      orderCreatedAt = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      
      orderDetails = {
        'customer_name': widget.customerName,
        'phone_number': widget.customerPhone,
        'email': widget.customerEmail,
        'payment_method': selectedPaymentMethod,
        'mpesa_number': selectedPaymentMethod == 'MPESA' ? mpesaNumberController.text : 'N/A',
        'total_amount': widget.totalAmount,
        'status': orderStatus,
        'created_at': orderCreatedAt,
      };

      isLoading = false;
      showConfirmation = true;
    });
  }

  Widget _buildPaymentForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Payment Method:',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Card(
          color: const Color.fromRGBO(62, 62, 61, 1),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                RadioListTile<String>(
                  title: const Text('MPESA', style: TextStyle(color: Colors.white)),
                  value: 'MPESA',
                  groupValue: selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentMethod = value!;
                    });
                  },
                ),
                if (selectedPaymentMethod == 'MPESA')
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: mpesaNumberController,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'M-PESA Number',
                        labelStyle: TextStyle(color: Colors.white70),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70),
                        ),
                      ),
                    ),
                  ),
                RadioListTile<String>(
                  title: const Text('Credit Card', style: TextStyle(color: Colors.white)),
                  value: 'CREDIT_CARD',
                  groupValue: selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentMethod = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Cash', style: TextStyle(color: Colors.white)),
                  value: 'CASH',
                  groupValue: selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentMethod = value!;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading ? null : confirmOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 120, 170, 255),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: isLoading
                ? const CircularProgressIndicator()
                : const Text(
                    'Confirm Order',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmationScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Order Confirmation',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Card(
          color: const Color.fromRGBO(62, 62, 61, 1),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildConfirmationDetail('Customer Name', orderDetails['customer_name'] ?? ''),
                _buildConfirmationDetail('Phone Number', orderDetails['phone_number'] ?? ''),
                _buildConfirmationDetail('Email', orderDetails['email'] ?? ''),
                _buildConfirmationDetail('Car', orderDetails['car_name'] ?? ''),
                _buildConfirmationDetail('Payment Method', orderDetails['payment_method'] ?? ''),
                if (orderDetails['payment_method'] == 'MPESA')
                  _buildConfirmationDetail('M-PESA Number', orderDetails['mpesa_number'] ?? ''),
                _buildConfirmationDetail('Pickup Date', orderDetails['pickup_date'] ?? ''),
                _buildConfirmationDetail('Return Date', orderDetails['return_date'] ?? ''),
                _buildConfirmationDetail('Total Amount', 'Ksh ${orderDetails['total_amount']?.toStringAsFixed(2) ?? '0.00'}'),
                _buildConfirmationDetail('Status', orderDetails['status'] ?? ''),
                const SizedBox(height: 20),
                const Divider(color: Colors.white30),
                const SizedBox(height: 20),
                const Text(
                  'Important Information:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'The car is to be picked up at our offices in Kiambu Road',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Contact Information:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Phone: +254 712 345 678\nEmail: info@remycarrentals.com\nAddress: Kiambu Road, Nairobi',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 120, 170, 255),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Done',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmationDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(30, 30, 30, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(30, 30, 30, 1),
        title: Text(
          showConfirmation ? 'Order Confirmation' : 'Payment Details',
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(16.0),
            child: showConfirmation ? _buildConfirmationScreen() : _buildPaymentForm(),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    mpesaNumberController.dispose();
    super.dispose();
  }
}