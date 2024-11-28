import 'package:camp_organizer/presentation/authentication/login_screen.dart';
import 'package:camp_organizer/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/Profile/logistics_profile_bloc.dart';
import '../../../bloc/Profile/logistics_profile_event.dart';
import '../../../bloc/Profile/logistics_profile_state.dart';

import '../../../utils/app_colors.dart';

class LogisticsProfile extends StatefulWidget {
  @override
  _LogisticsProfile createState() => _LogisticsProfile();
}

class _LogisticsProfile extends State<LogisticsProfile>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late LogisticsProfileBloc _LogisticsProfileBloc;

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
    _LogisticsProfileBloc = LogisticsProfileBloc()..add(FetchDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _LogisticsProfileBloc,
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
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.lightBlueAccent, Colors.lightBlue],
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
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue,
                    Colors.lightBlueAccent,
                    Colors.lightBlue
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
              child: BlocBuilder<LogisticsProfileBloc, LogisticsProfileState>(
                builder: (context, state) {
                  if (state is LogisticsProfileLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is LogisticsProfileLoaded) {
                    final employee = state.employee;
                    return Column(
                      children: [
                        const SizedBox(height: 15),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 500),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          child: Text(
                            employee['firstName'] +
                                    " " +
                                    employee['lastName'] ??
                                'N/A',
                            style: TextStyle(
                              fontFamily: 'LeagueSpartan',
                            ),
                          ),
                        ),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 500),
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 15),
                          child: Text(
                            employee['role'] ?? 'N/A',
                            style: TextStyle(
                              fontFamily: 'LeagueSpartan',
                            ),
                          ),
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
                  } else if (state is LogisticsProfileError) {
                    return Center(
                      child: Text(
                        'Error+${state.errorMessage}',
                        style: TextStyle(
                          fontFamily: 'LeagueSpartan',
                        ),
                      ),
                    );
                  }
                  return const Center(
                    child: Text(
                      "No data available",
                      style: TextStyle(
                        fontFamily: 'LeagueSpartan',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
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
            color: Colors.blueAccent,
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
