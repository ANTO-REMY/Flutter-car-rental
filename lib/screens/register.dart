import 'package:flutter/material.dart';
import 'package:flutter_cat1/screens/homepage.dart';
import 'package:flutter_cat1/screens/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen(email: emailController.text, password: passwordController.text,)),
            );
          },
        ),
        title: const Text('Create Your Account'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 40, 40, 40), // Dark gray
                  Color.fromARGB(255, 100, 100, 100), // Mid gray
                  Color.fromARGB(255, 160, 160, 160), // Light gray
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(20), 
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 33, 33, 33), 
                    borderRadius: BorderRadius.circular(10), 
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),
                     
                      SizedBox(
                        width: 400,
                        child: _buildTextField('Full Name', fullNameController, 'Please enter your full name'),
                      ),
                      const SizedBox(height: 16),
                  
                      SizedBox(
                        width: 400,
                        child: _buildTextField('Email', emailController, 'Please enter a valid email', TextInputType.emailAddress),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: 400,
                        child: _buildTextField('Password', passwordController, 'Please enter a password', TextInputType.text),
                      ),
                      const SizedBox(height: 16),
                     
                      SizedBox(
                        width: 400,
                        child: _buildButton(
                          text: 'Register',
                          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                          textColor: Colors.white, 
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              registerUser(context);  // Register user when the button is pressed
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, String validationMessage, [TextInputType keyboardType = TextInputType.text]) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: hint,
        filled: true,
        fillColor: const Color.fromARGB(255, 255, 255, 255), 
        hintStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      ),
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.black),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validationMessage;
        }
        return null;
      },
    );
  }

  Widget _buildButton({required String text, required Color backgroundColor, required Color textColor, required VoidCallback onPressed}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(fontSize: 16)),
    );
  }

  Future<void> registerUser(BuildContext context) async {
    final url = Uri.parse('https://tujengeane.co.ke/CarRental/signup.php?fullname=${Uri.encodeComponent(fullNameController.text)}&email=${Uri.encodeComponent(emailController.text)}&password=${Uri.encodeComponent(passwordController.text)}');

    try {
      final response = await http.get(url);
      final responseData = jsonDecode(response.body);

      if (responseData['code'] == 1) {
        // Save user data to SharedPreferences after successful registration
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('fullName', fullNameController.text);
        await prefs.setString('email', emailController.text);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message']),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen(email: emailController.text, password: passwordController.text,)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message'] ?? 'Registration failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}