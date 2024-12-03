import 'package:camp_organizer/bloc/auth/auth_bloc.dart';
import 'package:camp_organizer/widgets/bottom_navigation_bar/camp_incharge_nav_bar.dart';
import 'package:camp_organizer/widgets/bottom_navigation_bar/finance_nav_bar.dart';
import 'package:camp_organizer/widgets/bottom_navigation_bar/fluid_bottom_navigation_bar.dart';
import 'package:camp_organizer/widgets/bottom_navigation_bar/logistics_nav_bar.dart';
import 'package:camp_organizer/widgets/bottom_navigation_bar/onsite_management_nav_bar.dart';
import 'package:camp_organizer/widgets/bottom_navigation_bar/post_camp_nav_bar.dart';
import 'package:camp_organizer/widgets/bottom_navigation_bar/super_admin_bottom_navigation_bar.dart';
import 'package:camp_organizer/widgets/button/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';

import '../../widgets/bottom_navigation_bar/admin_bottom_navigation_bar.dart';

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

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            if (state.role == 'CampOrganizer') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => CurvedBottomNavigationBar()),
                (Route<dynamic> route) =>
                    false, // This removes all previous routes
              );
            } else if (state.role == 'OnSiteManagement') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => OnSiteManagement()),
                (Route<dynamic> route) =>
                    false, // This removes all previous routes
              );
            } else if (state.role == 'CampIncharge') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => CampInchargeNavBar()),
                (Route<dynamic> route) =>
                    false, // This removes all previous routes
              );
            } else if (state.role == 'Accountant') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => FinanceNavBar()),
                (Route<dynamic> route) =>
                    false, // This removes all previous routes
              );
            } else if (state.role == 'Logistics') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LogisticsNavBar()),
                (Route<dynamic> route) =>
                    false, // This removes all previous routes
              );
            } else if (state.role == 'Followup') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => PostCampNavBar()),
                (Route<dynamic> route) =>
                    false, // This removes all previous routes
              );
            } else if (state.role == 'admin') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => AdminBottomNavigationBar()),
                (Route<dynamic> route) =>
                    false, // This removes all previous routes
              );
            } else {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => SuperAdminBottomNavigationBar()),
                (Route<dynamic> route) =>
                    false, // This removes all previous routes
              );
            }
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.error, color: Colors.white),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        state.message,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                duration: Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return Center(
              child: Lottie.asset(
                'assets/preloader.json',
              ),
            );
          }
          return SingleChildScrollView(
            child: Center(
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
                        Image.asset("assets/logo1.png").animate().scale(
                            duration: const Duration(milliseconds: 1200),
                            curve: Curves.elasticOut),
                    //    SizedBox(height: 40),
            
                        // Username Field
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            prefixIcon:
                                Icon(Icons.person, color: Color(0xff0097b2)),
                            labelText: 'Employee Code',
                            labelStyle: TextStyle(
                              color: Color(0xff0097b2),
                              fontFamily: 'LeagueSpartan',
                            ),
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
                          controller: _passwordController,
                          decoration: InputDecoration(
                            prefixIcon:
                                Icon(Icons.lock, color: Color(0xff0097b2)),
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              color: Color(0xff0097b2),
                              fontFamily: 'LeagueSpartan',
                            ),
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
                        CustomButton(
                                text: "Login",
                                onPressed: () {
                                  final email = _emailController.text;
                                  final password = _passwordController.text;
                                  BlocProvider.of<AuthBloc>(context).add(
                                    SignInRequested(email, password),
                                  );
                                })
                            .animate()
                            .move(
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
        },
      ),
    );
  }
}
