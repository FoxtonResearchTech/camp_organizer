import 'package:camp_organizer/connectivity_checker.dart';
import 'package:camp_organizer/presentation/Analytics/dashboard_analytics.dart';
import 'package:camp_organizer/presentation/Event/add_event.dart';
import 'package:camp_organizer/presentation/dashboard/camp_organizer.dart';
import 'package:camp_organizer/presentation/profile/camp-organizer_profile.dart';
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
    AnimatedRotatingPieChartWithGrid(),
    AddEvent(),
    DashboardScreen(),
    UserProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return ConnectivityChecker(
        child: Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        height: 60.0,
        items: <Widget>[
          Icon(Icons.analytics_outlined,
              size: 30,
              color: _currentIndex == 0 ? AppColors.textBlue : Colors.white),
          Icon(Icons.event_note,
              size: 30,
              color: _currentIndex == 1 ? AppColors.textBlue : Colors.white),
          Icon(Icons.fact_check_rounded,
              size: 30,
              color: _currentIndex == 2 ? AppColors.textBlue : Colors.white),
          Icon(Icons.person,
              size: 30,
              color: _currentIndex == 3 ? AppColors.textBlue : Colors.white),
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
    ));
  }
}
