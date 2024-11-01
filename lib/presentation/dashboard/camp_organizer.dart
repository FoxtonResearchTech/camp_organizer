import 'package:camp_organizer/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Screen size parameters
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Beautiful App Bar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0, // Remove default elevation
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryBlue,
                AppColors.accentBlue,
                AppColors.lightBlue,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Handle notification button press
            },
          ),
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // Handle settings button press
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
            Animation<double> animation = CurvedAnimation(
              parent: _controller,
              curve: Interval(
                (1 / 5) * index, // Animate each item sequentially
                1.0,
                curve: Curves.easeOut,
              ),
            );
            _controller.forward(); // Start the animation when building

            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0, 0.2), // Start slightly below
                  end: Offset.zero, // End at original position
                ).animate(animation),
                child: Column(
                  children: [
                    // Information Container
                    Container(
                      height: screenHeight * 0.3, // Responsive height
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white60,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.date_range,
                                      size: screenWidth * 0.07, // Responsive icon size
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      '12-2-2024',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54,
                                        fontSize: screenWidth * 0.05, // Responsive font size
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.watch_later,
                                      size: screenWidth * 0.07, // Responsive icon size
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Morning',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54,
                                        fontSize: screenWidth * 0.05, // Responsive font size
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            ..._buildInfoText(screenWidth, 'CSI Trust'),
                            ..._buildInfoText(screenWidth, 'Marthandam, near ppk hospital'),
                            ..._buildInfoText(screenWidth, 'test@gmail.com'),
                            ..._buildInfoText(screenWidth, '65415874155'),

                            // Horizontal Timeline Container
                            Container(
                              height: screenHeight * 0.1, // Increased height for timeline container
                              width: double.infinity,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    _buildTimelineTile(
                                      isFirst: true,
                                      color: Colors.yellow,
                                      icon: Icons.check,
                                      text: 'Processing',
                                      screenWidth: screenWidth,
                                      lineBeforeColor: Colors.green,
                                      lineAfterColor: Colors.green,
                                    ),
                                    _buildTimelineTile(
                                      color: Colors.blue,
                                      icon: Icons.pending,
                                      text: 'Confirmed',
                                      screenWidth: screenWidth,
                                      lineBeforeColor: Colors.green,
                                      lineAfterColor: Colors.grey,
                                    ),
                                    _buildTimelineTile(
                                      isLast: true,
                                      color: Colors.grey,
                                      icon: Icons.circle,
                                      text: 'Completed',
                                      screenWidth: screenWidth,
                                      lineBeforeColor: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Helper method to build timeline tile with responsive styles
  Widget _buildTimelineTile({
    required Color color,
    required IconData icon,
    required String text,
    required double screenWidth,
    Color? lineBeforeColor,
    Color? lineAfterColor,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return TimelineTile(
      axis: TimelineAxis.horizontal,
      alignment: TimelineAlign.center,
      isFirst: isFirst,
      isLast: isLast,
      indicatorStyle: IndicatorStyle(
        width: screenWidth * 0.09, // Increased indicator size
        color: color,
        iconStyle: IconStyle(
          iconData: icon,
          color: Colors.white,
          fontSize: screenWidth * 0.05, // Increased icon size
        ),
      ),
      endChild: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8.0), // Adjusted padding
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black54,
            fontSize: screenWidth * 0.05, // Increased font size for timeline text
          ),
        ),
      ),
      beforeLineStyle: LineStyle(color: lineBeforeColor ?? Colors.grey, thickness: 3), // Slightly thicker lines
      afterLineStyle: LineStyle(color: lineAfterColor ?? Colors.grey, thickness: 3),
    );
  }

  // Helper method to build info text with responsive font size
  List<Widget> _buildInfoText(double screenWidth, String text) {
    return [
      Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black54,
          fontSize: screenWidth * 0.05, // Responsive font size
        ),
      ),
    ];
  }
}
