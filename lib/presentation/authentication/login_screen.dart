import 'package:camp_organizer/widgets/bottom_navigation_bar/fluid_bottom_navigation_bar.dart';
import 'package:camp_organizer/widgets/button/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CampOrganizerLoginPage extends StatefulWidget {
  @override
  _CampOrganizerLoginPageState createState() => _CampOrganizerLoginPageState();
}

class _CampOrganizerLoginPageState extends State<CampOrganizerLoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideInAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _slideInAnimation =
        Tween<Offset>(begin: Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fadeInAnimation,
          child: SlideTransition(
            position: _slideInAnimation,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo and Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.local_hospital,
                        color: Colors.blueAccent,
                        size: 40,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Hospital Management System',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ).animate().scale(
                      duration: const Duration(milliseconds: 1200),
                      curve: Curves.elasticOut),
                  SizedBox(height: 40),

                  // Username Field
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person, color: Colors.blueAccent),
                      labelText: 'Username',
                      labelStyle: TextStyle(color: Colors.blueAccent),
                      filled: true,
                      fillColor: Colors.blue[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ).animate().fade(
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.easeInOut),
                  SizedBox(height: 20),

                  // Password Field
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock, color: Colors.blueAccent),
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.blueAccent),
                      filled: true,
                      fillColor: Colors.blue[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    obscureText: true,
                  ).animate().fade(
                      delay: const Duration(milliseconds: 200),
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.easeInOut),
                  SizedBox(height: 30),

                  // Login Button
                  CustomButton(text: "Login", onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => CurvedBottomNavigationBar()),
                          (Route<dynamic> route) => false, // Remove all previous routes
                    );
                  }).animate().move(
                      delay: const Duration(milliseconds: 400),
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.easeInOut),

                  // Forgot Password Link
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
