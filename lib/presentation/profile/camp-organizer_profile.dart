import 'package:flutter/material.dart';


class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(-1.0, 0.0), // Starts from the left
      end: Offset.zero, // Ends at the original position
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward(); // Start the animation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlueAccent, Colors.lightBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => NotificationPage(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    const begin = Offset(-1.0, 0.0); // Start from the left
                    const end = Offset.zero; // End at the original position
                    const curve = Curves.easeInOut;
                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);
                    return SlideTransition(position: offsetAnimation, child: child);
                  },
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Header Background with transition animation
          AnimatedContainer(
            duration: Duration(seconds: 1),
            height: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.lightBlueAccent, Colors.lightBlue],
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
            duration: Duration(seconds: 1),
            padding: EdgeInsets.only(top: 50),
            child: Column(
              children: [
                SizedBox(height: 15),
                AnimatedDefaultTextStyle(
                  duration: Duration(milliseconds: 500),
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  child: Text('M. Ramesh'),
                ),
                AnimatedDefaultTextStyle(
                  duration: Duration(milliseconds: 500),
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 15),
                  child: Text('Camp Coordinator'),
                ),
                SizedBox(height: 30),
                Expanded(
                  child: AnimatedContainer(
                    duration: Duration(seconds: 1),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    margin: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: Offset(0, 3),
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
                            subtitle: '12-2-2003',
                            slideAnimation: _slideAnimation,
                          ),
                          ProfileInfoTile(
                            icon: Icons.bloodtype,
                            title: 'Blood Group',
                            subtitle: 'B+ ive',
                            slideAnimation: _slideAnimation,
                          ),
                          ProfileInfoTile(
                            icon: Icons.supervised_user_circle,
                            title: 'Employee id',
                            subtitle: 'CC234890',
                            slideAnimation: _slideAnimation,
                          ),
                          ProfileInfoTile(
                            icon: Icons.search,
                            title: 'Camp Reports',
                            subtitle: 'Search',
                            slideAnimation: _slideAnimation,
                          ),
                          ProfileInfoTile(
                            icon: Icons.copy,
                            title: 'Commutative Reports',
                            subtitle: 'Search',
                            slideAnimation: _slideAnimation,
                          ),
                          ProfileInfoTile(
                            icon: Icons.login,
                            title: 'Logout',
                            subtitle: 'logout',
                            slideAnimation: _slideAnimation,
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
          padding: EdgeInsets.all(10),
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
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
      ),
    );
  }
}

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Center(
        child: Text('Notification Page'),
      ),
    );
  }
}
