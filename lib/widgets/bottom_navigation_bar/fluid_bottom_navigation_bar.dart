import 'package:camp_organizer/presentation/dashboard/camp_organizer.dart';
import 'package:camp_organizer/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class CurvedBottomNavigationBar extends StatefulWidget {
  @override
  _CurvedBottomNavigationBarState createState() =>
      _CurvedBottomNavigationBarState();
}

class _CurvedBottomNavigationBarState extends State<CurvedBottomNavigationBar> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
  DashboardScreen(),
    Center(child: Text('Search Page', style: TextStyle(fontSize: 30))),
    Center(child: Text('Profile Page', style: TextStyle(fontSize: 30))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        height: 60.0,
        items: <Widget>[
          Icon(Icons.home, size: 30, color: _currentIndex == 0 ? AppColors.textBlue : Colors.white),
          Icon(Icons.search, size: 30, color: _currentIndex == 1 ? AppColors.textBlue : Colors.white),
          Icon(Icons.person, size: 30, color: _currentIndex == 2 ? AppColors.textBlue : Colors.white),
        ],
        color: AppColors.primaryBlue,
        buttonBackgroundColor: AppColors.lightGray,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
