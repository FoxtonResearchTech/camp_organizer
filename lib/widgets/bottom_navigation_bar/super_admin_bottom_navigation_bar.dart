import 'package:camp_organizer/presentation/Admin/admin_approval.dart';
import 'package:camp_organizer/presentation/Analytics/dashboard_analytics.dart';
import 'package:camp_organizer/presentation/Event/add_event.dart';
import 'package:camp_organizer/presentation/profile/admin_profile.dart';
import 'package:camp_organizer/presentation/profile/camp-organizer_profile.dart';
import 'package:camp_organizer/presentation/profile/super_admin_profile.dart';
import 'package:camp_organizer/presentation/superAdmin/super_admin_camp_search_screen.dart';
import 'package:camp_organizer/presentation/superAdmin/super_admin_commutative_report_search_screen.dart';
import 'package:camp_organizer/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import '../../presentation/Admin/dashboard.dart';
import '../../presentation/superAdmin/super_admin_dashboard.dart';

class SuperAdminBottomNavigationBar extends StatefulWidget {
  @override
  _SuperAdminBottomNavigationBarState createState() =>
      _SuperAdminBottomNavigationBarState();
}

class _SuperAdminBottomNavigationBarState
    extends State<SuperAdminBottomNavigationBar> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    SuperAdminDashboardScreen(),
    SuperAdminCampSearchScreen(),
    SuperAdminUserProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        height: 60.0,
        items: <Widget>[
          Icon(Icons.analytics_outlined,
              size: 30,
              color: _currentIndex == 0 ? AppColors.textBlue : Colors.white),
          Icon(Icons.checklist,
              size: 30,
              color: _currentIndex == 1 ? AppColors.textBlue : Colors.white),
          Icon(Icons.filter_list_alt,
              size: 30,
              color: _currentIndex == 2 ? AppColors.textBlue : Colors.white),
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
