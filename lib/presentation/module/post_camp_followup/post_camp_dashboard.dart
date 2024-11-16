import 'package:camp_organizer/presentation/module/post_camp_followup/post_camp_follow.dart';
import 'package:camp_organizer/presentation/module/post_camp_followup/post_camp_follow_completed.dart';
import 'package:camp_organizer/presentation/module/post_camp_followup/post_camp_profile.dart';
import 'package:flutter/material.dart';

import '../../notification/notification.dart';

class PostCampDashboard extends StatefulWidget {
  const PostCampDashboard({super.key});

  @override
  State<PostCampDashboard> createState() => _PostCampDashboardState();
}

class _PostCampDashboardState extends State<PostCampDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Post Camp Followup',
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
                MaterialPageRoute(builder: (context) => NotificationPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            _buildDashboardItem(
              icon: Icons.timer_sharp,
              label: 'Camp Timeline',
              subtitle: '',
              itemsCount: '3 Events',
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationPage()),
                );
                print("Camp Timeline tapped");
              },
            ),
            _buildDashboardItem(
              icon: Icons.person_pin_rounded,
              label: 'Profile',
              subtitle: '',
              itemsCount: '4 items',
              color: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PostCampProfile()),
                );
                print("Profile tapped");
              },
            ),
            _buildDashboardItem(
              icon: Icons.work_history_sharp,
              label: 'Upcoming Project',
              subtitle: '',
              itemsCount: '',
              color: Colors.red,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationPage()),
                );
                print("Upcoming Project tapped");
              },
            ),

            _buildDashboardItem(
              icon: Icons.follow_the_signs_sharp,
              label: 'Follow up',
              subtitle: '',
              itemsCount: '',
              color: Colors.purple,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PostCampFollow()),
                );
                print("camp incharge");
              },
            ),

            _buildDashboardItem(
              icon: Icons.mark_email_read_outlined,
              label: 'Follow Completed',
              subtitle: '',
              itemsCount: '',
              color: Colors.lightGreenAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PostCampFollowCompleted()),
                );
                print("camp incharge");
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardItem({
    required IconData icon,
    required String label,
    required String subtitle,
    required String itemsCount,
    required Color color,
    required VoidCallback onTap,
  }) {
    bool isTapped = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return GestureDetector(
          onTapDown: (_) {
            setState(() => isTapped = true);
          },
          onTapUp: (_) {
            setState(() => isTapped = false);
            onTap();
          },
          onTapCancel: () {
            setState(() => isTapped = false);
          },
          child: AnimatedScale(
            scale: isTapped ? 0.95 : 1.0,
            duration: const Duration(milliseconds: 100),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              decoration: BoxDecoration(
                color: isTapped ? Colors.blue.withOpacity(0.1) : Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 40, color: color),
                  SizedBox(height: 10),
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                  if (itemsCount.isNotEmpty) ...[
                    SizedBox(height: 4),
                    Text(
                      itemsCount,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}
