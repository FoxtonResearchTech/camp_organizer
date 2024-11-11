import 'package:flutter/material.dart';

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

  Employee({required this.name, required this.empCode, required this.designation});
}


class _ManageEmployeeAccountState extends State<ManageEmployeeAccount> {
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

  // Function to edit an employee (add actual functionality as needed)
  void _editEmployee(int index) {
    // You could navigate to a form to edit employee details
    // For now, it just shows a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit ${employees[index].name}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Registration',
          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlueAccent, Colors.lightBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>NotificationPage()));
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: employees.length,
        itemBuilder: (context, index) {
          final employee = employees[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: ListTile(
              title: Text(employee.name),
              subtitle: Text('Code: ${employee.empCode} | Designation: ${employee.designation}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _editEmployee(index),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteEmployee(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
