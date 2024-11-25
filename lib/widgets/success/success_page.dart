import 'package:camp_organizer/presentation/Analytics/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessPage extends StatefulWidget {
  final Widget targetScreen; // Add a parameter for the target screen
  final String text;
  SuccessPage({required this.targetScreen, required this.text});

  @override
  _SuccessPageState createState() => _SuccessPageState();
}


class _SuccessPageState extends State<SuccessPage> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation; // Animation for fade effect
  late Animation<Offset> _slideAnimation; // Animation for slide effect

  @override
  void initState() {
    super.initState();

    // Initialize fade animation
    _fadeController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..forward();

    // Fade animation from transparent to opaque
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeInOut,
      ),
    );

    // Slide animation to move from bottom to top
    _slideAnimation = Tween<Offset>(
      begin: Offset(0.0, 1.0), // Start position (below the screen)
      end: Offset(0.0, 0.0),   // End position (center of the screen)
    ).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  // Function to handle the "Done" button press
  void _onDonePressed() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => widget.targetScreen), // Use the passed target screen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SlideTransition(
        position: _slideAnimation,  // Apply the slide animation
        child: FadeTransition(
          opacity: _fadeAnimation, // Apply the fade effect
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Lottie animation
                Lottie.asset('assets/success.json', width: 200, height: 200),

                SizedBox(height: 40),

                // Success text
                Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.contentColorBlue,
                  ),
                ),

                SizedBox(height: 20),

                // "Done" button
                ElevatedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text('Done',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.contentColorBlue,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
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
