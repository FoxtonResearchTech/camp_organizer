import 'package:camp_organizer/bloc/Employee/employee_update_bloc.dart';
import 'package:camp_organizer/bloc/Employee/employee_update_state.dart';
import 'package:camp_organizer/presentation/module/super_admin/super_admin_edit_employee_account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/Employee/employee_update_event.dart';
import '../../../utils/app_colors.dart';
import '../../notification/notification.dart';

class SuperAdminManageEmployeeAccount extends StatefulWidget {
  const SuperAdminManageEmployeeAccount({super.key});

  @override
  State<SuperAdminManageEmployeeAccount> createState() =>
      _SuperAdminManageEmployeeAccountState();
}

class Employee {
  final String name;
  final String empCode;
  final String designation;
  final String password;

  Employee(
      {required this.name,
      required this.empCode,
      required this.designation,
      required this.password});
}

class _SuperAdminManageEmployeeAccountState
    extends State<SuperAdminManageEmployeeAccount> {
  late EmployeeUpdateBloc _employeeUpdateBloc;

  @override
  void initState() {
    super.initState();
    _employeeUpdateBloc = EmployeeUpdateBloc();
    _employeeUpdateBloc.add(FetchDataEvent());
  }

  @override
  void dispose() {
    _employeeUpdateBloc.close(); // Close the bloc when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EmployeeUpdateBloc>(
      create: (context) => _employeeUpdateBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'User Registration',
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
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.lightBlueAccent, Colors.lightBlue],
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
              print(employees);
              return RefreshIndicator(
                  onRefresh: () async {
                    context.read<EmployeeUpdateBloc>().add(FetchDataEvent());
                  },
                  child: ListView.builder(
                    itemCount: employees.length,
                    itemBuilder: (context, index) {
                      final employee = employees[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 16),
                        child: ListTile(
                          title: Text(
                            employee['firstName'] ?? "N/A",
                            style: TextStyle(
                              fontFamily: 'LeagueSpartan',
                            ),
                          ),
                          subtitle: Text(
                            'Code: ${employee['empCode'] ?? "N/A"} | Designation: ${employee['designation'] ?? "N/A"}',
                            style: TextStyle(
                              fontFamily: 'LeagueSpartan',
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SuperAdminEditEmployeeAccount(
                                        employee: Employee(
                                            name:
                                                employee['firstName'] ?? "N/A",
                                            empCode:
                                                employee['empCode'] ?? "N/A",
                                            designation:
                                                employee['designation'] ??
                                                    "N/A",
                                            password:
                                                employee['password' ?? "N/A"]),
                                        index: index,
                                        onUpdate:
                                            (updatedIndex, updatedEmployee) {
                                          setState(() {
                                            employees[updatedIndex] = {
                                              'firstName': updatedEmployee.name,
                                              'empCode':
                                                  updatedEmployee.empCode,
                                              'designation':
                                                  updatedEmployee.designation,
                                              'password':
                                                  updatedEmployee.password
                                            };
                                          });
                                        },
                                        onDelete: (deletedIndex) {
                                          setState(() {
                                            employees.removeAt(deletedIndex);
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  bool? confirmDelete = await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                          'Delete',
                                          style: TextStyle(
                                            fontFamily: 'LeagueSpartan',
                                          ),
                                        ),
                                        content: const Text(
                                          'Are you sure you want to Delete?',
                                          style: TextStyle(
                                            fontFamily: 'LeagueSpartan',
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                color: AppColors.accentBlue,
                                                fontFamily: 'LeagueSpartan',
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: const Text('Delete',
                                                style: TextStyle(
                                                  color: AppColors.accentBlue,
                                                  fontFamily: 'LeagueSpartan',
                                                )),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  if (confirmDelete == true) {
                                    final empCode = employee['empCode'];
                                    if (empCode != null && empCode.isNotEmpty) {
                                      context.read<EmployeeUpdateBloc>().add(
                                            DeleteEmployeeEvent(empCode),
                                          );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Center(
                                              child: Text("Employee Deleted")),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Center(
                                              child: Text(
                                                  "Invalid employee code")),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ));
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
}
