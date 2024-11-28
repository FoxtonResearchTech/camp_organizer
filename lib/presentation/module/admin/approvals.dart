import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../utils/app_colors.dart';

class Approvals extends StatefulWidget {
  const Approvals({super.key});

  @override
  State<Approvals> createState() => _ApprovalsState();
}

class _ApprovalsState extends State<Approvals> {
  DateTime? selectedDate;
  String selectedPeriod = 'AM';
  TextEditingController dateController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  // Example data for approvals
  final List<Map<String, String>> approvals = [
    {
      'employeeName': 'Kathiresan',
      'date': '12-8-2024',
      'time': 'Morning',
      'organizationName': 'CSI Trust',
      'address': 'Marthandam, Near Overbridge, KK Dist.',
      'phone': '6381599574',
    },
    {
      'employeeName': 'John Doe',
      'date': '13-8-2024',
      'time': 'Afternoon',
      'organizationName': 'XYZ Foundation',
      'address': 'Some Place, City Center, KK Dist.',
      'phone': '1234567890',
    },
    {
      'employeeName': 'John Doe',
      'date': '13-8-2024',
      'time': 'Afternoon',
      'organizationName': 'XYZ Foundation',
      'address': 'Some Place, City Center, KK Dist.',
      'phone': '1234567890',
    },
    {
      'employeeName': 'John Doe',
      'date': '13-8-2024',
      'time': 'Afternoon',
      'organizationName': 'XYZ Foundation',
      'address': 'Some Place, City Center, KK Dist.',
      'phone': '1234567890',
    },
    // Add more approvals as needed
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void _updateDateText() {
    if (selectedDate != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);
      dateController.text = '$formattedDate $selectedPeriod';
    }
  }

  void _showRejectDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text("Reason for Rejection",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _reasonController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Reason",
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: "Enter your reason here...",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                final reason = _reasonController.text;
                Navigator.of(context).pop();
                _reasonController.clear();
              },
              child: Text("Submit", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 800;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Approvals',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryBlue,
                AppColors.accentBlue,
                AppColors.lightBlue,
              ],
              end: Alignment.topLeft,
              begin: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Row(
        children: [
          if (isDesktop)
            Expanded(
              flex: 1,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(color: Colors.lightBlueAccent),
                    child: Text("SCMS-PHP",
                        style: TextStyle(color: Colors.white, fontSize: 24)),
                  ),
                  _buildDrawerItem(Icons.dashboard, "Dashboard"),
                  _buildDrawerItem(Icons.people, "Add Employee"),
                  _buildDrawerItem(Icons.receipt, "Reports"),
                  Divider(),
                  _buildDrawerItem(Icons.supervised_user_circle, "Approvals"),
                  _buildDrawerItem(Icons.settings, "Settings"),
                  _buildDrawerItem(Icons.logout, "Logout"),
                ],
              ),
            ),
          Expanded(
            flex: 3,
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: approvals.length,
              itemBuilder: (context, index) {
                final approval = approvals[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "Medical Camp Approval Info",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                          ),
                          SizedBox(height: 40),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    AssetImage('assets/avatar.png'),
                              ),
                              SizedBox(width: 30),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildDetailRow("Employee Name",
                                        approval['employeeName'] ?? ''),
                                    SizedBox(height: 20),
                                    Row(
                                      children: [
                                        _buildDetailRowWithIcon(
                                            Icons.date_range,
                                            approval['date'] ?? ''),
                                        SizedBox(width: 100),
                                        _buildDetailRowWithIcon(
                                            Icons.access_time,
                                            approval['time'] ?? ''),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    _buildDetailRow("Organization Name",
                                        approval['organizationName'] ?? ''),
                                    SizedBox(height: 20),
                                    _buildDetailRow(
                                        "Address", approval['address'] ?? ''),
                                    SizedBox(height: 20),
                                    _buildDetailRow(
                                        "Phone", approval['phone'] ?? ''),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildCustomActionButton(
                                  Icons.verified_user_outlined,
                                  "Accept",
                                  Colors.green), // Use custom button
                              _buildCustomActionButton(
                                  Icons.remove_moderator_outlined,
                                  "Reject",
                                  Colors.red,
                                  _showRejectDialog),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      drawer: isDesktop ? null : _buildMobileDrawer(),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {},
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
              fontSize: 18,
            ),
          ),
          Text(value, style: TextStyle(color: Colors.black, fontSize: 17)),
        ],
      ),
    );
  }

  Widget _buildDetailRowWithIcon(IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange, size: 20),
          SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(color: Colors.black, fontSize: 17),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomActionButton(IconData icon, String label, Color color,
      [VoidCallback? onPressed]) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 24),
        decoration: BoxDecoration(
          color: color, // Set your custom background color here
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 6),
            Text(label, style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Drawer _buildMobileDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.teal),
            child: Text("SCMS-PHP",
                style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          _buildDrawerItem(Icons.dashboard, "Dashboard"),
          _buildDrawerItem(Icons.people, "Add Employee"),
          _buildDrawerItem(Icons.receipt, "Reports"),
          Divider(),
          _buildDrawerItem(Icons.supervised_user_circle, "Approvals"),
          _buildDrawerItem(Icons.settings, "Settings"),
          _buildDrawerItem(Icons.logout, "Logout"),
        ],
      ),
    );
  }
}
