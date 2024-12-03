import 'package:camp_organizer/presentation/module/super_admin/selected_employee_camp_search_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../widgets/button/custom_button.dart';
import '../admin/Individual_reports.dart';
import 'admin_selected_employee_commutative_search_screen.dart';
import 'admin_selected_employee_search_search_screen.dart';

class AdminCampsReportsPage extends StatefulWidget {
  final String name;
  final String position;
  final String empCode;
  AdminCampsReportsPage({
    required this.name,
    required this.position,
    required this.empCode,
  });
  @override
  _AdminCampsReportsPage createState() => _AdminCampsReportsPage();
}

class _AdminCampsReportsPage extends State<AdminCampsReportsPage> {
  List<String> employeeNames = [];
  String? selectedEmployee;
  String? reportType;
  List<Map<String, dynamic>> camps = [];
  bool isLoading = true;
  List<String> campDocIds = [];

  @override
  void initState() {
    super.initState();
    fetchEmployees();
  }

  Future<void> fetchEmployees() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('employees')
          .where('role', whereIn: ['admin', 'CampOrganizer']).get();

      setState(() {
        employeeNames = querySnapshot.docs
            .map((doc) => "${doc['firstName']} ${doc['lastName']}")
            .toList();
      });
    } catch (e) {
      print('Error fetching employees: $e');
    }
  }

  Future<void> fetchCamps() async {
    try {
      List<String>? nameParts = selectedEmployee?.split(' ');
      String? firstName = nameParts?[0];
      String? lastName = nameParts!.length > 1 ? nameParts[1] : null;

      QuerySnapshot employeeSnapshot;

      if (lastName != null) {
        // Query for both firstName and lastName
        employeeSnapshot = await FirebaseFirestore.instance
            .collection('employees')
            .where('firstName', isEqualTo: firstName)
            .where('lastName', isEqualTo: lastName)
            .get();
      } else {
        // Query only for firstName
        employeeSnapshot = await FirebaseFirestore.instance
            .collection('employees')
            .where('firstName', isEqualTo: firstName)
            .get();
      }

      if (employeeSnapshot.docs.isNotEmpty) {
        String employeeId = employeeSnapshot.docs.first.id;

        QuerySnapshot campsSnapshot = await FirebaseFirestore.instance
            .collection('employees')
            .doc(employeeId)
            .collection('camps')
            .get();

        setState(() {
          campDocIds = campsSnapshot.docs.map((doc) => doc.id).toList();
          camps = campsSnapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching camps: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Camp Organizers Reports',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Employee Selection
            const Text(
              'Select an Employee:',
              style: TextStyle(
                  fontFamily: 'LeagueSpartan',
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Colors.blueAccent, width: 1),
              ),
              child: DropdownButton<String>(
                value: selectedEmployee,
                isExpanded: true,
                underline: Container(), // Removes default underline
                dropdownColor: Colors.white,
                hint: const Text(
                  'Choose an employee',
                  style: TextStyle(
                    fontFamily: 'LeagueSpartan',
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                items: employeeNames.map((name) {
                  return DropdownMenuItem(
                    value: name,
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontFamily: 'LeagueSpartan',
                        fontSize: 16,
                        color: Colors.black,fontWeight: FontWeight.w500
                      ),
                    ),
                  );
                }).toList(),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.blueAccent,
                  size: 24,
                ),
                onChanged: (value) {
                  setState(() {
                    selectedEmployee = value;
                  });
                },
              ),
            )



            // Report Type Selection
         ,   const SizedBox(height: 20),
            const Text(
              'Select Report Type:',
              style: TextStyle(
                  fontFamily: 'LeagueSpartan',
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Radio<String>(
                        value: 'Individual',
                        activeColor: const Color(0xFF0097b2),
                        groupValue: reportType,
                        onChanged: (value) {
                          setState(() {
                            reportType = value;
                          });
                        },
                      ),
                      const Text(
                        'Individual reports',
                        style: TextStyle(fontFamily: 'LeagueSpartan',fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Radio<String>(
                        value: 'Commutative',
                        activeColor: const Color(0xFF0097b2),
                        groupValue: reportType,
                        onChanged: (value) {
                          setState(() {
                            reportType = value;
                          });
                        },
                      ),
                      const Text(
                        'Cumulative Report',
                        style: TextStyle(fontFamily: 'LeagueSpartan',fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // View Reports Button
            const SizedBox(height: 20),
            Center(
              child: CustomButton(
                text: 'View Reports',
                onPressed: () {
                  if (selectedEmployee != null && reportType != null) {
                    if (reportType == 'Individual') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AdminSelectedEmployeeCampSearchScreen(
                                  employeeName: selectedEmployee!,
                                  camps: camps,
                                )),
                      );
                    } else if (reportType == 'Commutative') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AdminSelectedEmployeeCommutativeReport(
                            name: widget.name,
                            position: widget.position,
                            empCode: widget.empCode,
                            employeeName: selectedEmployee!,
                          ),
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please select both an employee and a report type.',
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
