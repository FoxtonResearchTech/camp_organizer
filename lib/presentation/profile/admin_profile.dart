import 'package:camp_organizer/admin_add_employee.dart';
import 'package:camp_organizer/bloc/Profile/profile_state.dart';
import 'package:camp_organizer/connectivity_checker.dart';
import 'package:camp_organizer/presentation/Admin/admin_camp_search_screen.dart';
import 'package:camp_organizer/presentation/authentication/login_screen.dart';
import 'package:camp_organizer/presentation/module/admin/manage_employee_account.dart';
import 'package:camp_organizer/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../admin_add_employee.dart';
import '../../bloc/Profile/admin_profile_bloc.dart';
import '../../bloc/Profile/admin_profile_state.dart';
import '../../utils/app_colors.dart';
import '../module/admin/AdminCampReports.dart';
import '../module/super_admin/camps_reports.dart';
import '../module/admin/manage_employee_account.dart';
import 'admin_commutative_reports_search_screen.dart';
import 'commutative_reports_search_screen.dart';
import '../../bloc/Profile/admin_profile_event.dart';

class AdminUserProfilePage extends StatefulWidget {
  @override
  _AdminUserProfilePageState createState() => _AdminUserProfilePageState();
}

class _AdminUserProfilePageState extends State<AdminUserProfilePage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late AdminProfileBloc _AdminProfileBloc;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0), // Starts from the left
      end: Offset.zero, // Ends at the original position
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward(); // Start the animation
    _AdminProfileBloc = AdminProfileBloc()..add(FetchDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityChecker(
        child: BlocProvider(
      create: (context) => _AdminProfileBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'LeagueSpartan',
            ),
          ),
          centerTitle: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0097b2),
                  Color(0xFF0097b2).withOpacity(1),
                  Color(0xFF0097b2).withOpacity(0.8)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Header Background with transition animation
            AnimatedContainer(
              duration: const Duration(seconds: 1),
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0097b2),
                    Color(0xFF0097b2).withOpacity(1),
                    Color(0xFF0097b2).withOpacity(0.8)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Container(),
            ),
            // Profile Content with smooth transitions
            AnimatedPadding(
              duration: const Duration(seconds: 1),
              padding: const EdgeInsets.only(top: 50),
              child: BlocBuilder<AdminProfileBloc, AdminProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoading) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Color(0xFF0097b2),
                    ));
                  } else if (state is AdminProfileLoaded) {
                    final employee = state.employee;
                    return Column(
                      children: [
                        const SizedBox(height: 15),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 500),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'LeagueSpartan',
                            color: Colors.white,
                          ),
                          child: Text(employee['firstName'] +
                                  " " +
                                  employee['lastName'] ??
                              'N/A'),
                        ),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 500),
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'LeagueSpartan',
                              fontSize: 15),
                          child: Text(employee['role'] ?? 'N/A'),
                        ),
                        const SizedBox(height: 30),
                        Expanded(
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 30),
                            margin: const EdgeInsets.only(top: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 5,
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Animated Profile Info Tiles
                                  ProfileInfoTile(
                                    icon: Icons.person,
                                    title: 'DOB',
                                    subtitle: employee['dob'] ?? 'N/A',
                                    slideAnimation: _slideAnimation,
                                  ),
                                  ProfileInfoTile(
                                    icon: Icons.people,
                                    title: 'Gender',
                                    subtitle: employee['gender'] ?? 'N/A',
                                    slideAnimation: _slideAnimation,
                                  ),
                                  ProfileInfoTile(
                                    icon: Icons.bloodtype,
                                    title: 'Blood Group',
                                    subtitle: employee['bloodGroup'] ?? 'N/A',
                                    slideAnimation: _slideAnimation,
                                  ),
                                  ProfileInfoTile(
                                    icon: Icons.place,
                                    title: 'Lane 1',
                                    subtitle: employee['lane1'] ?? 'N/A',
                                    slideAnimation: _slideAnimation,
                                  ),
                                  ProfileInfoTile(
                                    icon: Icons.place,
                                    title: 'Lane 2',
                                    subtitle: employee['lane2'] ?? 'N/A',
                                    slideAnimation: _slideAnimation,
                                  ),
                                  ProfileInfoTile(
                                    icon: Icons.location_city_outlined,
                                    title: 'State',
                                    subtitle: employee['state'] ?? 'N/A',
                                    slideAnimation: _slideAnimation,
                                  ),
                                  ProfileInfoTile(
                                    icon: Icons.my_location,
                                    title: 'Pincode',
                                    subtitle: employee['pincode'] ?? 'N/A',
                                    slideAnimation: _slideAnimation,
                                  ),
                                  ProfileInfoTile(
                                    icon: Icons.supervised_user_circle,
                                    title: 'Employee id',
                                    subtitle: employee['empCode'] ?? 'N/A',
                                    slideAnimation: _slideAnimation,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AdminAddEmployee(),
                                        ),
                                      );
                                    },
                                    child: ProfileInfoTile(
                                      icon: Icons.create,
                                      title: 'Create Employee',
                                      subtitle: 'Accounts',
                                      slideAnimation: _slideAnimation,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ManageEmployeeAccount(),
                                        ),
                                      );
                                    },
                                    child: ProfileInfoTile(
                                      icon: Icons.manage_accounts,
                                      title: 'Manage Employee',
                                      subtitle: 'Accounts',
                                      slideAnimation: _slideAnimation,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AdminCampsReportsPage(
                                            name:
                                                '${employee['firstName']} ${employee['lastName']}',
                                            position: employee['role'] ?? 'N/A',
                                            empCode:
                                                employee['empCode'] ?? 'N/A',
                                          ),
                                        ),
                                      );
                                    },
                                    child: ProfileInfoTile(
                                      icon: Icons.search,
                                      title: 'Camp organizers Reports',
                                      subtitle: 'Reports',
                                      slideAnimation: _slideAnimation,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AdminCampSearchScreen(),
                                        ),
                                      );
                                    },
                                    child: ProfileInfoTile(
                                      icon: Icons.search,
                                      title: 'Camp Reports',
                                      subtitle: 'Search',
                                      slideAnimation: _slideAnimation,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AdminCommutativeReportsSearchScreen(
                                                  name:
                                                      '${employee['firstName']} ${employee['lastName']}',
                                                  position:
                                                      employee['role'] ?? 'N/A',
                                                  empCode:
                                                      employee['empCode'] ??
                                                          'N/A',
                                                )),
                                      );
                                    },
                                    child: ProfileInfoTile(
                                      icon: Icons.copy,
                                      title: 'Cumulative Reports',
                                      subtitle: 'Search',
                                      slideAnimation: _slideAnimation,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ManageEmployeeAccount()));
                                    },
                                    child: ProfileInfoTile(
                                      icon: Icons.how_to_reg,
                                      title: 'Manage Employee',
                                      subtitle: 'Manage account',
                                      slideAnimation: _slideAnimation,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AdminAddEmployee()));
                                    },
                                    child: ProfileInfoTile(
                                      icon: Icons.add_to_queue,
                                      title: 'Add Employee',
                                      subtitle: 'Create employee',
                                      slideAnimation: _slideAnimation,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      bool? confirmLogout = await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text(
                                              'Logout',
                                              style: TextStyle(
                                                fontFamily: 'LeagueSpartan',
                                              ),
                                            ),
                                            content: const Text(
                                              'Are you sure you want to Logout?',
                                              style: TextStyle(
                                                fontFamily: 'LeagueSpartan',
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, false),
                                                child: const Text('Cancel',
                                                    style: TextStyle(
                                                      color:
                                                          AppColors.accentBlue,
                                                      fontFamily:
                                                          'LeagueSpartan',
                                                    )),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  AuthRepository().signOut();
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              CampOrganizerLoginPage()));
                                                },
                                                child: const Text('Logout',
                                                    style: TextStyle(
                                                      color:
                                                          AppColors.accentBlue,
                                                      fontFamily:
                                                          'LeagueSpartan',
                                                    )),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      if (confirmLogout == true) {}
                                    },
                                    child: ProfileInfoTile(
                                      icon: Icons.login,
                                      title: 'Logout',
                                      subtitle: 'logout',
                                      slideAnimation: _slideAnimation,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (state is AdminProfileError) {
                    return Center(
                      child: Text('Error+${state.errorMessage}'),
                    );
                  }
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Color(0xFF0097b2),
                  ));
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Animation<Offset> slideAnimation;

  ProfileInfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.slideAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slideAnimation,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Color(0xFF0097b2),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'LeagueSpartan',
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontFamily: 'LeagueSpartan',
          ),
        ),
      ),
    );
  }
}

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: const Center(
        child: Text('Notification Page'),
      ),
    );
  }
}
