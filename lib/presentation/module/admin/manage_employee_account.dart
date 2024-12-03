import 'package:camp_organizer/bloc/Employee/employee_update_bloc.dart';
import 'package:camp_organizer/bloc/Employee/employee_update_event.dart';
import 'package:camp_organizer/bloc/Employee/employee_update_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageEmployeeAccount extends StatefulWidget {
  const ManageEmployeeAccount({super.key});

  @override
  State<ManageEmployeeAccount> createState() => _ManageEmployeeAccountState();
}

class _ManageEmployeeAccountState extends State<ManageEmployeeAccount> {
  late EmployeeUpdateBloc _employeeUpdateBloc;
  Map<String, bool> employeeActiveStatus = {}; // Correctly initialize map

  @override
  void initState() {
    super.initState();
    _employeeUpdateBloc = EmployeeUpdateBloc();
    _employeeUpdateBloc.add(FetchDataEvent());
  }

  @override
  void dispose() {
    _employeeUpdateBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EmployeeUpdateBloc>(
      create: (context) => _employeeUpdateBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Manage Accounts',
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
          leading: IconButton(
            icon: const Icon(
              CupertinoIcons.back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: BlocBuilder<EmployeeUpdateBloc, EmployeeUpdateState>(
          bloc: _employeeUpdateBloc,
          builder: (context, state) {
            if (state is EmployeeUpdateLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is EmployeeUpdateLoaded) {
              final employees = state.employeesData;

              // Initialize local isActive state for each employee
              for (var employee in employees) {
                employeeActiveStatus.putIfAbsent(employee['empCode'], () => employee['isActive'] ?? false);
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<EmployeeUpdateBloc>().add(FetchDataEvent());
                },
                child: ListView.builder(
                  itemCount: employees.length,
                  itemBuilder: (context, index) {
                    final employee = employees[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Name: ${employee['firstName'] ?? "N/A"} ${employee['lastName'] ?? "N/A"}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'LeagueSpartan',
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Code: ${employee['empCode'] ?? "N/A"}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'LeagueSpartan',
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Designation: ${employee['role'] ?? "N/A"}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'LeagueSpartan',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Switch(
                                  value: employeeActiveStatus[employee['empCode']] ?? false,
                                  onChanged: (value) async {
                                    // Debug print to check if value is toggling
                                    print('Toggling status for ${employee['empCode']}: $value');

                                    setState(() {
                                      // Update the value in the local map
                                      employeeActiveStatus[employee['empCode']] = value;
                                    });

                                    // Debug print to check the map status after update
                                    print('Updated employeeActiveStatus: $employeeActiveStatus');

                                    // Call your update function to change status
                                    await _updateUserStatus(
                                      employee['empCode'] ?? '',
                                      value,  // value is a bool, which is correct
                                    );

                                    // You can also print after calling the update function to check Firestore update status
                                    print('User status updated in Firestore for ${employee['empCode']} to $value');
                                  },
                                  activeColor: Colors.green,
                                  inactiveThumbColor: Colors.red,
                                  inactiveTrackColor: Colors.red.withOpacity(0.3),
                                )
                              ],
                            ),
                            const Divider(height: 20),
                            _buildInfoRow(Icons.home, employee['lane1'] ?? "No Address Provided"),
                            _buildInfoRow(null, employee['lane2'] ?? ""),
                            _buildInfoRow(null, employee['pinCode'] ?? ""),
                            _buildInfoRow(Icons.location_city, employee['state'] ?? "No State Provided"),
                            _buildInfoRow(Icons.cake, employee['dob'] ?? "No DOB Provided"),
                            const SizedBox(height: 10),
                            _buildInfoRow(Icons.email, '${employee['empCode']}@gmail.com'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            } else if (state is EmployeeUpdateError) {
              return Center(
                child: Text(
                  'Error: ${state.errorMessage}',
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
    );
  }

  Widget _buildInfoRow(IconData? icon, String text) {
    return Row(
      children: [
        if (icon != null) Icon(icon, color: Colors.blue),
        if (icon != null) const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'LeagueSpartan',
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _updateUserStatus(String empCode, bool status) async {
    try {
      // Query the Firestore collection to find the employee document by empCode
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('employees')
          .where('empCode', isEqualTo: empCode) // Use empCode to find the document
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Get the document ID of the first document in the snapshot
        String docId = snapshot.docs.first.id;

        // Update the employee's isActive status using the document ID
        await FirebaseFirestore.instance
            .collection('employees')
            .doc(docId)
            .update({'isActive': status});

        // Optionally, handle success message or other logic
        print('Status updated for $empCode to $status');
      } else {
        // Handle case if no employee document is found with the given empCode
        print('Employee with empCode $empCode not found');
      }
    } catch (e) {
      // Handle any errors that occur
      print('Error updating status: $e');
    }
  }
}
