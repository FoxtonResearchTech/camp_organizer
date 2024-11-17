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

  // Sample employee data
  List<Employee> employees = [
    Employee(name: 'John Doe', empCode: 'E001', designation: 'Manager'),
    Employee(name: 'Jane Smith', empCode: 'E002', designation: 'Developer'),
    Employee(name: 'Mike Johnson', empCode: 'E003', designation: 'Designer'),
  ];

  // Function to delete an employee
  void _deleteEmployee(int index) {
    setState(() {
      employees.removeAt(index);
    });
  }

  // Function to edit an employee
  void _editEmployee(int index) {
    final employee = employees[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditEmployeeAccount(
          employee: employee,
          index: index,
          onUpdate: (int index, Employee updatedEmployee) {
            setState(() {
              employees[index] = updatedEmployee;
            });
          },
          onDelete: (int index) {
            _deleteEmployee(index);
          },
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit ${employees[index].name}')),
    );
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
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationPage()));
              },
            ),
          ],
        ),
        body: BlocBuilder<EmployeeUpdateBloc, EmployeeUpdateState>(
          bloc: _employeeUpdateBloc,
          builder: (context, state) {
            if (state is EmployeeUpdateLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is EmployeeUpdateLoaded) {
              final employees = state.employeesData;
              print(employees);
              return ListView.builder(
                itemCount: employees.length,
                itemBuilder: (context, index) {
                  final employee = employees[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    child: ListTile(
                      title: Text(employee['firstName'] ?? "N/A"),
                      subtitle: Text(
                          'Code: ${employee['empCode'] ?? "N/A"} | Designation: ${employee['designation'] ?? "N/A"}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editEmployee(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteEmployee(index),
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
