import 'package:camp_organizer/bloc/Employee/employee_update_bloc.dart';
import 'package:camp_organizer/bloc/Employee/employee_update_event.dart';
import 'package:camp_organizer/bloc/Employee/employee_update_state.dart';
import 'package:camp_organizer/connectivity_checker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SuperAdminManageEmployeeAccount extends StatefulWidget {
  const SuperAdminManageEmployeeAccount({super.key});

  @override
  State<SuperAdminManageEmployeeAccount> createState() => _SuperAdminManageEmployeeAccountState();
}

class _SuperAdminManageEmployeeAccountState extends State<SuperAdminManageEmployeeAccount> {
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
    return ConnectivityChecker(
        child: BlocProvider<EmployeeUpdateBloc>(
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
                    employeeActiveStatus.putIfAbsent(
                        employee['empCode'], () => employee['isActive'] ?? false);
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<EmployeeUpdateBloc>().add(FetchDataEvent());
                    },
                    child: ListView.builder(
                      itemCount: employees.length,
                      itemBuilder: (context, index) {
                        final employee = employees[index];
                        return AnimatedPadding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          duration: const Duration(milliseconds: 300),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                              'Password: ${employee['password'] ?? "N/A"}',
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
                                      AnimatedSwitcher(
                                        duration: const Duration(milliseconds: 300),
                                        child: Switch(
                                          value: employeeActiveStatus[
                                          employee['empCode']] ??
                                              false,
                                          onChanged: (value) async {
                                            setState(() {
                                              employeeActiveStatus[
                                              employee['empCode']] = value;
                                            });
                                            await _updateUserStatus(
                                              employee['empCode'] ?? '',
                                              value,
                                            );
                                          },
                                          activeColor: Colors.green,
                                          inactiveThumbColor: Colors.red,
                                          inactiveTrackColor:
                                          Colors.red.withOpacity(0.3),
                                        ),
                                      )
                                    ],
                                  ),
                                  const Divider(height: 20),
                                  _buildInfoRow(Icons.home,
                                      employee['lane1'] ?? "No Address Provided"),
                                  _buildInfoRow(null, employee['lane2'] ?? ""),
                                  _buildInfoRow(null, employee['pinCode'] ?? ""),
                                  _buildInfoRow(Icons.location_city,
                                      employee['state'] ?? "No State Provided"),
                                  _buildInfoRow(Icons.cake,
                                      employee['dob'] ?? "No DOB Provided"),
                                  const SizedBox(height: 10),
                                  _buildInfoRow(Icons.email,
                                      '${employee['empCode']}@gmail.com'),
                                ],
                              ),
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
        ));
  }

  Widget _buildInfoRow(IconData? icon, String text) {
    return AnimatedOpacity(
      opacity: text.isEmpty ? 0.5 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: Row(
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
      ),
    );
  }

  Future<void> _updateUserStatus(String empCode, bool status) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('employees')
          .where('empCode', isEqualTo: empCode)
          .get();

      if (snapshot.docs.isNotEmpty) {
        String docId = snapshot.docs.first.id;

        await FirebaseFirestore.instance
            .collection('employees')
            .doc(docId)
            .update({'isActive': status});
        print('Status updated for $empCode to $status');
      } else {
        print('Employee with empCode $empCode not found');
      }
    } catch (e) {
      print('Error updating status: $e');
    }
  }
}
