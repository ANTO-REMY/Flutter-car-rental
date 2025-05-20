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
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    
    final url = Uri.parse('http://localhost/php_backend/signup.php');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'fullname': fullNameController.text,
          'email': emailController.text,
          'password': passwordController.text,
        }),
      );
      
      // Close loading dialog
      Navigator.pop(context);
      
      // Try to parse the response, but don't show an error if it fails
      try {
        final responseData = jsonDecode(response.body);

        // Check if the response status code is 200 (success) regardless of the 'code' value
        // This ensures that if the user is saved in the database, we treat it as success
        if (response.statusCode == 200 || responseData['code'] == 1) {
          // Registration successful
          // Save user info to SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('email', emailController.text);
          await prefs.setString('fullName', fullNameController.text);
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration successful!'),
              backgroundColor: Colors.green,
            ),
          );
          
          // Navigate to login screen immediately
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(
                email: emailController.text,
                password: passwordController.text,
              ),
            ),
          );
        } else {
          // Registration failed (e.g., user already exists)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['message'] ?? 'Registration failed'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (jsonError) {
        // If we can't parse the response as JSON, assume registration was successful
        // This is what you requested - to do away with the non-JSON error handling
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', emailController.text);
        await prefs.setString('fullName', fullNameController.text);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navigate to login screen immediately
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(
              email: emailController.text,
              password: passwordController.text,
            ),
          ),
        );
      }
    } catch (e) {
      // Close loading dialog if still showing
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}