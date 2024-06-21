import 'package:farm_records_management_system/farmer/farmer_DAO.dart';
import 'package:farm_records_management_system/profileManagement/registration.dart';
import 'package:farm_records_management_system/screens/home_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  void _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    var farmer = await FarmerDAO.instance.getFarmerByEmailAndPassword(email, password);

    if (farmer != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage(farmer: {},)),
      );
    } else {
      setState(() {
        _errorMessage = 'Invalid email or password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/background_green.jpg', // Background image path
              fit: BoxFit.cover,
            ),
          ),
          // Dark overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          // Login Form
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.45), // Increased transparency
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15.0,
                    ),
                  ],
                ),
                width: 300, // Reduced width
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo and Title
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 20.0),
                          child: Image.asset(
                            'assets/logo.png', // Add your logo image path here
                            height: 60, // Reduced height
                          ),
                        ),
                        Text(
                          'FARM RECORDS MANAGEMENT SYSTEM',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0, // Reduced font size
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 3, 70, 22),
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15), // Reduced spacing
                    Text(
                      'Welcome! Please log in to continue',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.0, // Reduced font size
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 12, 51, 31),
                      ),
                    ),
                    SizedBox(height: 15), // Reduced spacing
                    // User Icon
                    CircleAvatar(
                      radius: 30, // Reduced radius
                      backgroundColor: Colors.green[100],
                      child: Icon(
                        Icons.person,
                        size: 30, // Reduced icon size
                        color: Color.fromARGB(255, 19, 64, 22),
                      ),
                    ),
                    SizedBox(height: 15), // Reduced spacing
                    // Email TextField
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email ID',
                        labelStyle: TextStyle(color: const Color.fromARGB(255, 24, 72, 27)),
                        hintText: 'Enter your email',
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.email, color: Color.fromARGB(255, 45, 109, 47)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                      ),
                      style: TextStyle(fontSize: 14.0), // Reduced font size
                    ),
                    SizedBox(height: 10), // Reduced spacing
                    // Password TextField
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Color.fromARGB(255, 19, 59, 20)),
                        hintText: 'Enter your password',
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.lock, color: Color.fromARGB(255, 40, 103, 42)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                      ),
                      obscureText: true,
                      style: TextStyle(fontSize: 14.0), // Reduced font size
                    ),
                    SizedBox(height: 15), // Reduced spacing
                    // Login Button
                    ElevatedButton(
                      onPressed: _login,
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 16.0), // Reduced font size
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 22, 74, 25),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12), // Reduced padding
                      ),
                    ),
                    SizedBox(height: 10), // Reduced spacing
                    if (_errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          _errorMessage,
                          style: TextStyle(color: Colors.red, fontSize: 12.0), // Reduced font size
                        ),
                      ),
                    Text(
                      "Don't have an account?",
                      style: TextStyle(color: Color.fromARGB(221, 0, 0, 0), fontSize: 14.0,fontWeight: FontWeight.bold), // Reduced font size
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegistrationScreen()),
                        );
                      },
                      child: Text(
                        'Register here',
                        style: TextStyle(
                          color: Color.fromARGB(255, 28, 82, 30),
                          fontSize: 16.0, // Reduced font size
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
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
    );
  }
}
