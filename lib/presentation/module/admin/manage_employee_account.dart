import 'package:camp_organizer/bloc/Employee/employee_update_bloc.dart';
import 'package:camp_organizer/bloc/Employee/employee_update_state.dart';
import 'package:camp_organizer/presentation/module/admin/edit_employee_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/Employee/employee_update_event.dart';
import '../../notification/notification.dart';

class ManageEmployeeAccount extends StatefulWidget {
  const ManageEmployeeAccount({super.key});

  @override
  State<ManageEmployeeAccount> createState() => _ManageEmployeeAccountState();
}

class Employee {
  final String name;
  final String empCode;
  final String designation;

  Employee(
      {required this.name, required this.empCode, required this.designation});
}

class _ManageEmployeeAccountState extends State<ManageEmployeeAccount> {
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
            'Manage Account',
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
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
              onPressed: () {
                Navigator.pop(context);
              },
              icon:Icon(Icons.arrow_back_ios,color: Colors.white,)),
        ),
        body: BlocBuilder<EmployeeUpdateBloc, EmployeeUpdateState>(
          bloc: _employeeUpdateBloc,
          builder: (context, state) {
            if (state is EmployeeUpdateLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is EmployeeUpdateLoaded) {
              final employees = state.employeesData;
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: employees.length,
                itemBuilder: (context, index) {
                  final employee = employees[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text(
                        employee['firstName'] ?? "N/A",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        'Emp id: ${employee['empCode'] ?? "N/A"} | Designation: ${employee['role'] ?? "N/A"}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],fontWeight: FontWeight.w500
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8), backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditEmployeeAccount(
                                    employee: Employee(
                                      name: employee['firstName'] ?? "N/A",
                                      empCode: employee['empCode'] ?? "N/A",
                                      designation:
                                      employee['role'] ?? "N/A",
                                    ),
                                    index: index,
                                    onUpdate: (updatedIndex, updatedEmployee) {
                                      setState(() {
                                        employees[updatedIndex] = {
                                          'firstName': updatedEmployee.name,
                                          'empCode': updatedEmployee.empCode,
                                          'designation':
                                          updatedEmployee.designation,
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
                            child: const Text("Edit",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white),),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8), backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              final empCode = employee['empCode'];
                              if (empCode != null && empCode.isNotEmpty) {
                                context.read<EmployeeUpdateBloc>().add(
                                  DeleteEmployeeEvent(empCode),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Invalid employee code")),
                                );
                              }
                            },
                            child: const Text("Delete",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is EmployeeUpdateError) {
              return Center(
                child: Text('Error: ${state.errorMessage}'),
              );
            }
            return const Center(
              child: Text("No data available"),
            );
          },
        ),
      ),
    );
  }
}
