import 'package:flutter/material.dart';

// Notification model to hold data
class Notification {
  final String date; // Date of the notification
  final String time; // Time of the notification
  final String title;
  final String location;
  final String email;
  final String phoneNumber;
  final bool isAccepted; // Added field to indicate acceptance status

  Notification({
    required this.date,
    required this.time,
    required this.title,
    required this.location,
    required this.email,
    required this.phoneNumber,
    required this.isAccepted, // Initialize acceptance status
  });
}

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 600), // Increased duration
      vsync: this,
    );

    // Create a list of animations for each notification
    _animations = List.generate(2, (index) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(index * 0.4, 1.0, curve: Curves.easeIn), // Adjusted interval
        ),
      );
    });

    // Start the animation when the page loads
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Sample notification data
    List<Notification> notifications = [
      Notification(
        date: '12-02-2024',
        time: '08:00 AM',
        title: 'CSI Trust - Meeting',
        location: 'Marthandam, near PPK Hospital',
        email: 'test@gmail.com',
        phoneNumber: '65415874155',
        isAccepted: true, // Accepted notification
      ),
      Notification(
        date: '12-02-2024',
        time: '02:00 PM',
        title: 'CSI Trust - Event',
        location: 'Marthandam, near XYZ Hospital',
        email: 'test2@gmail.com',
        phoneNumber: '1234567890',
        isAccepted: false, // Rejected notification
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
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
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios,color: Colors.white,)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: notifications.asMap().entries.map((entry) {
              int index = entry.key;
              Notification notification = entry.value;

              return FadeTransition(
                opacity: _animations[index],
                child: Column(
                  children: [
                    _buildNotificationCard(
                        screenHeight, screenWidth, notification),
                    SizedBox(height: 24), // Space between notifications
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(
      double screenHeight, double screenWidth, Notification notification) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: screenHeight * 0.3,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(
          color: notification.isAccepted ? Colors.green : Colors.red,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.date_range, color: Colors.orange),
                    SizedBox(width: 8),
                    Text(
                      notification.date,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.watch_later, color: Colors.orange),
                    SizedBox(width: 8),
                    Text(
                      notification.time,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            ..._buildInfoText(screenWidth, notification.title),
            ..._buildInfoText(screenWidth, notification.location),
            ..._buildInfoText(screenWidth, notification.email),
            ..._buildInfoText(screenWidth, notification.phoneNumber),

            SizedBox(height: 10),
            Text(
              'Notification Date: ${notification.date}',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black54,
                fontSize: screenWidth * 0.04,
              ),
            ),
            Text(
              'Notification Time: ${notification.time}',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black54,
                fontSize: screenWidth * 0.04,
              ),
            ),
            SizedBox(height: 10),
            Text(
              notification.isAccepted ? 'Accepted' : 'Rejected',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: notification.isAccepted ? Colors.green : Colors.red,
                fontSize: screenWidth * 0.04,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildInfoText(double screenWidth, String text) {
    return [
      Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black54,
          fontSize: screenWidth * 0.04,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      SizedBox(height: 2),
    ];
  }
}
