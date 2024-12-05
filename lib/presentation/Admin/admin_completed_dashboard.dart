import 'dart:convert';

import 'package:camp_organizer/bloc/approval/adminapproval_bloc.dart';
import 'package:camp_organizer/connectivity_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../bloc/approval/adminapproval_event.dart';
import '../../utils/app_colors.dart';

class AdminCompletedDashboard extends StatefulWidget {
  final Map<String, dynamic> employee;
  final String? campID;
  final String? employeeID;
  final String? campName;
  final String? campDate;
  final String? employeemail;

  const AdminCompletedDashboard(
      {Key? key,
      required this.employee,
      this.campID,
      this.employeeID,
      this.campDate,
      this.campName,
      this.employeemail})
      : super(key: key);

  @override
  State<AdminCompletedDashboard> createState() =>
      _AdminCompletedDashboardState();
}

class _AdminCompletedDashboardState extends State<AdminCompletedDashboard>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _reason;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _buttonScaleAnimation;
  late Animation<double> _buttonFadeAnimation;

  @override
  void initState() {
    super.initState();
    _reason = TextEditingController();
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
    print("Camp ID: ${widget.campID}");
    print("Employee ID: ${widget.employeeID}");
  }

  @override
  void dispose() {
    _reason.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return ConnectivityChecker(
        child: Scaffold(
      appBar: AppBar(
        title: const Text(
          'Camp Completed Details',
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
                                fontFamily: 'LeagueSpartan',
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
                                fontFamily: 'LeagueSpartan',
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
        padding: EdgeInsets.only(
            top: screenHeight / 35,
            bottom: screenHeight / 25,
            left: screenWidth / 25,
            right: screenWidth / 25),
        child: SizedBox(
          width: screenWidth / 2.5,
          height: screenHeight / 17.5,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              backgroundColor: Color(0xFF0097b2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            label: const Text(
              "Done",
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'LeagueSpartan',
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    ));
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
          fontWeight: FontWeight.bold,
          fontFamily: 'LeagueSpartan',
          color: Colors.black87,
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
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          fontSize: screenWidth * 0.05,
          fontFamily: 'LeagueSpartan',
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

  Widget _buildDetailRow(String label, String value, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${label}:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontFamily: 'LeagueSpartan',
              fontSize:
                  screenWidth * 0.045, // Adjust the font size responsively
            ),
          ),
          SizedBox(width: screenWidth / 10),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black54, fontWeight: FontWeight.w500,
                fontFamily: 'LeagueSpartan',
                fontSize:
                    screenWidth * 0.045, // Adjust the font size responsively
              ),
              overflow: TextOverflow.ellipsis, // Handle long text overflow
              maxLines: 1, // Optional: limit the number of lines
            ),
          ),
        ],
      ),
    );
  }

  Future<void> sendAcceptEmail(
    String employeeId,
    List<dynamic> destId,
    String campName,
    String campDate,
  ) async {
    const String serviceId = 'service_m66gp4c'; // Your EmailJS Service ID
    const String templateId = 'template_gmya15j'; // Your EmailJS Template ID
    const String user_id = 'zA3pjW03a2sLLo51c'; // Public Key (user_id)
    const String privateKey = 'K2p5DmTapkR6qYcMPGhTQ'; // Private Key (API Key)

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $privateKey', // Send the private key as Bearer token
        },
        body: jsonEncode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': user_id, // Use the Public Key (user_id)
          'template_params': {
            'to_email': destId, // Recipient's email
            'employeeId': employeeId,
            'campName': campName,
            'campDate': campDate,
            'status': 'Accepted',
          },
        }),
      );

      if (response.statusCode == 200) {
        print('Email sent successfully!');
      } else {
        print('Failed to send email: ${response.statusCode}, ${response.body}');
      }
    } catch (error) {
      print('Error sending email: $error');
    }
  }
}
