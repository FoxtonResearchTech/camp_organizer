import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/animation.dart';

import '../../utils/app_colors.dart';
import 'EventDetailsEditingPage.dart';

class EventDetailsPage extends StatefulWidget {
  final Map<String, dynamic> employee;

  const EventDetailsPage({Key? key, required this.employee}) : super(key: key);

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _buttonScaleAnimation;
  late Animation<double> _buttonFadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1), // Slide from slightly below
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _buttonScaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _buttonFadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    // Start the animation when the page loads
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Camp Details',
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
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
                              size: screenWidth * 0.07,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.employee['campDate'],
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                                fontSize: screenWidth * 0.05,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.watch_later,
                              size: screenWidth * 0.07,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.employee['campTime'],
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                                fontSize: screenWidth * 0.05,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ..._buildDetailRows(screenWidth),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ScaleTransition(
              scale: _buttonScaleAnimation,
              child: FadeTransition(
                opacity: _buttonFadeAnimation,
                child: SizedBox(
                  width: screenWidth / 3,
                  height: screenHeight / 15,
                  child: ElevatedButton.icon(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      final eventDocRef = FirebaseFirestore.instance
                          .collection('employees').doc('osVjMnYxkRdBZAK8gp7hSGsVr1o1').collection("camps")
                          .doc('gXJPAMO0fMjObtqxlom5');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventDetailsEditingPage(
                            employee: widget.employee,
                            docRef: eventDocRef,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          widget.employee['campStatus'] == 'Waiting'
                              ? AppColors.accentBlue
                              : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    label: const Text(
                      "Edit",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            ScaleTransition(
              scale: _buttonScaleAnimation,
              child: FadeTransition(
                opacity: _buttonFadeAnimation,
                child: SizedBox(
                  width: screenWidth / 3,
                  height: screenHeight / 15,
                  child: ElevatedButton.icon(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    label: const Text(
                      "Edit",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDetailRows(double screenWidth) {
    return [
      _buildDetailRow('Camp Name', widget.employee['campName'], screenWidth),
      _buildDetailRow(
          'Organization', widget.employee['organization'], screenWidth),
      _buildDetailRow('Address', widget.employee['address'], screenWidth),
      _buildDetailRow('City', widget.employee['city'], screenWidth),
      _buildDetailRow('State', widget.employee['state'], screenWidth),
      _buildDetailRow('Pincode', widget.employee['pincode'], screenWidth),
      Text(
        "Concern Person1 Details :",
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black54,
          fontSize: screenWidth * 0.05,
        ),
      ),
      _buildDetailRow('Name', widget.employee['name'], screenWidth),
      _buildDetailRow('Position', widget.employee['position'], screenWidth),
      _buildDetailRow(
          'Phone Number 1', widget.employee['phoneNumber1'], screenWidth),
      _buildDetailRow(
          'Phone Number 2', widget.employee['phoneNumber1_2'], screenWidth),
      Text(
        "Concern Person2 Details :",
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black54,
          fontSize: screenWidth * 0.05,
        ),
      ),
      _buildDetailRow('Name', widget.employee['name2'], screenWidth),
      _buildDetailRow('Position', widget.employee['position2'], screenWidth),
      _buildDetailRow(
          'Phone Number 1', widget.employee['phoneNumber2'], screenWidth),
      _buildDetailRow(
          'Phone Number 2', widget.employee['phoneNumber2_2'], screenWidth),
      _buildDetailRow(
          'Camp Plan Type', widget.employee['campPlanType'], screenWidth),
      _buildDetailRow(
          'Road Access', widget.employee['roadAccess'], screenWidth),
      _buildDetailRow(
          'Total Square Feet', widget.employee['totalSquareFeet'], screenWidth),
      _buildDetailRow('Water Availability',
          widget.employee['waterAvailability'], screenWidth),
      _buildDetailRow('No Of Patients Expected',
          widget.employee['noOfPatientExpected'], screenWidth),
      _buildDetailRow(
          'Last Camp Done', widget.employee['lastCampDone'], screenWidth),
    ];
  }

  Widget _buildDetailRow(String label, String? value, double screenWidth) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: [
              Text(
                '$label: ',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                  fontSize: screenWidth * 0.05,
                ),
              ),
              Text(value ?? 'N/A'),
            ],
          ),
        ),
      ),
    );
  }
}
