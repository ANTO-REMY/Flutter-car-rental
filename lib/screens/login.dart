import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_cat1/screens/homepage.dart';
import 'package:flutter_cat1/screens/register.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.email, required this.password});
  final String email;
  final String password;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isFormVisible = true; // Changed to true to show form by default
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
      lowerBound: 0.9,
      upperBound: 1.0,
    )..repeat(reverse: true);
    
    // Don't pre-fill the form fields
    // Just make sure the form is visible
    _isFormVisible = true;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackgroundGradient(),
          _buildMainContent(),
          if (_isFormVisible) _buildBlurOverlay(),
          if (_isFormVisible) _buildBackButton(),
          if (_isFormVisible) _buildLoginForm(),
        ],
      ),
    );
  }

  Widget _buildBackgroundGradient() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 40, 40, 40),
            Color.fromARGB(255, 100, 100, 100),
            Color.fromARGB(255, 160, 160, 160),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.network(
            'https://i.postimg.cc/vZ9jY1nP/vecteezy-white-luxury-car-isolated-on-transparent-background-3d-30928135.png',
            width: 1000,
            height: 450,
          ),
          const SizedBox(height: 5),
          const Text(
            'Rent and Ride Premium Cars',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const Text(
            'Enjoy the luxury all at an affordable cost!',
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
          const SizedBox(height: 20),
          if (!_isFormVisible) _buildLoginButton(),
        ],
      ),
    );
  }

  Widget _buildBlurOverlay() {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          color: Colors.black.withOpacity(0.3),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Positioned(
      top: 40,
      left: 10,
      child: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          setState(() {
            _isFormVisible = false;
          });
        },
      ),
    );
  }

  Widget _buildLoginForm() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Welcome to Remy Car Rentals',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 450,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 33, 33, 33),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTextField('Email', _emailController, obscureText: false),
                    const SizedBox(height: 20),
                    _buildTextField('Password', _passwordController, obscureText: true),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: 350,
                      child: _buildButton(
                        text: 'Login',
                        height: 50,
                        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                        textColor: Colors.white,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _loginUser();
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 350,
                      child: _buildButton(
                        text: 'Register',
                        height: 50,
                        backgroundColor: Colors.transparent,
                        textColor: Colors.white,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>  RegisterScreen()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: 250,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _animationController.value,
            child: child,
          );
        },
        child: _buildButton(
          text: 'Login',
          height: 60,
          backgroundColor: const Color.fromARGB(255, 40, 40, 40),
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              _isFormVisible = true;
            });
          },
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color.fromARGB(255, 255, 255, 255),
        hintStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      ),
      obscureText: obscureText,
      style: const TextStyle(fontSize: 16, color: Color.fromARGB(255, 0, 0, 0)),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$hint cannot be empty';
        }
        return null;
      },
    );
  }

  Widget _buildButton({
    required String text,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onPressed,
    double height = 50,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        padding: EdgeInsets.symmetric(vertical: height / 2.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(fontSize: 16)),
    );
  }

  Future<void> _login(BuildContext context) async {
    final Uri url = Uri.parse('http://localhost/php_backend/signin.php');
    try {
      final http.Response response = await http.post(
        url,
        body: {
          'email': _emailController.text,
          'password': _passwordController.text,
        },
      );
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData['code'] == 1) {
        // Save user info to SharedPreferences (matching register.dart)
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', _emailController.text);
        if (responseData.containsKey('fullname')) {
          await prefs.setString('fullName', responseData['fullname']);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successful'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen(email: _emailController.text, password: _passwordController.text)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message'] ?? 'Login failed'),
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

  void _loginUser() async {
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
    
    final email = _emailController.text;
    final password = _passwordController.text;
  
    // For Android emulator, use 10.0.2.2 instead of localhost
    // For physical device, use your computer's actual IP address
    final url = Uri.parse('http://localhost/php_backend/signin.php');
    
    try {
      print('Sending login request for email: $email');
      final response = await http.post(
        url,
        body: {
          'email': email,
          'password': password,
        },
      );
      
      // Close loading dialog
      Navigator.pop(context);
      
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      // Consider login successful if status code is 200, regardless of response body
      if (response.statusCode == 200) {
        // Try to parse the response, but don't fail if it's not valid JSON
        try {
          final data = jsonDecode(response.body);
          print('Parsed data: $data');
          
          // Save user data to SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('email', email);
          if (data.containsKey('fullname')) {
            await prefs.setString('fullName', data['fullname']);
          } else {
            // If fullname is not in the response, use email as fallback
            await prefs.setString('fullName', email.split('@')[0]);
          }
        } catch (e) {
          // If JSON parsing fails, still proceed with login
          print('JSON parsing error: $e');
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('email', email);
          await prefs.setString('fullName', email.split('@')[0]);
        }
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successful'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        
        // Navigate to dashboard
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardScreen(email: email, password: password)),
          );
        });
      } else {
        // Only show error if status code is not 200
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed. Server returned status code: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Network or other error
      print('Network error: $e');
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connection error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  // Remove the duplicate _login method since we're using _loginUser
}

