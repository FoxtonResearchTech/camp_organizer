import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import '../../../widgets/Text Form Field/custom_text_form_field.dart';
import '../../notification/notification.dart';
import '../super_admin/super_admin_manage_employee_account.dart';

class SuperAdminEditEmployeeAccount extends StatefulWidget {
  final Employee employee;
  final int index;
  final Function(int, Employee) onUpdate;
  final Function(int) onDelete;

  const SuperAdminEditEmployeeAccount({
    Key? key,
    required this.employee,
    required this.index,
    required this.onUpdate,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<SuperAdminEditEmployeeAccount> createState() =>
      _SuperAdminEditEmployeeAccountState();
}

class _SuperAdminEditEmployeeAccountState
    extends State<SuperAdminEditEmployeeAccount> {
  late TextEditingController nameController;
  late TextEditingController empCodeController;
  late TextEditingController designationController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.employee.name);
    empCodeController = TextEditingController(text: widget.employee.empCode);
    designationController =
        TextEditingController(text: widget.employee.designation);
    passwordController = TextEditingController(text: widget.employee.password);
  }

  void _updateEmployee() async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('employees')
          .where('empCode', isEqualTo: widget.employee.empCode)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var docId = querySnapshot.docs.first.id;
        await FirebaseFirestore.instance
            .collection('employees')
            .doc(docId)
            .update({
          'firstName': nameController.text,
          'empCode': empCodeController.text,
          'designation': designationController.text,
          'password': passwordController.text,
        });

        widget.onUpdate(
          widget.index,
          Employee(
            name: nameController.text,
            empCode: empCodeController.text,
            designation: designationController.text,
            password: passwordController.text,
          ),
        );

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(
              child: Text('Employee updated successfully'),
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(
              child: Text('Employee document not found'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error updating employee: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(
            child: Text('Failed to update employee'),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _deleteEmployee() async {
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
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel',
                  style: TextStyle(
                    color: AppColors.accentBlue,
                    fontFamily: 'LeagueSpartan',
                  )),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
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
      try {
        // Query to find the employee document by empCode
        var querySnapshot = await FirebaseFirestore.instance
            .collection('employees')
            .where('empCode', isEqualTo: widget.employee.empCode)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          var docId = querySnapshot.docs.first.id;

          // Reference to the employee document
          var employeeDocRef =
              FirebaseFirestore.instance.collection('employees').doc(docId);

          // Delete the 'camps' subcollection documents
          var campsSnapshot = await employeeDocRef.collection('camps').get();
          for (var doc in campsSnapshot.docs) {
            await doc.reference.delete();
          }

          // Delete the main employee document after deleting the subcollection
          await employeeDocRef.delete();

          // Notify the parent widget and close the dialog
          widget.onDelete(widget.index);

          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Center(
                  child:
                      Text('Employee and related camps deleted successfully')),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Center(child: Text('Employee document not found')),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        print('Error deleting employee: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(child: Text('Failed to delete employee')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Update User Account',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextFormField(
              labelText: 'Name',
              controller: nameController,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextFormField(
              labelText: 'Employee Code',
              controller: empCodeController,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextFormField(
              labelText: 'Designation',
              controller: designationController,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextFormField(
              labelText: 'Password',
              controller: passwordController,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCustomActionButton(Icons.update_outlined, "Update",
                    Colors.green, _updateEmployee), // Use custom button
                _buildCustomActionButton(
                  Icons.delete_outline_outlined,
                  "Delete",
                  Colors.red,
                  _deleteEmployee,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomActionButton(IconData icon, String label, Color color,
      [VoidCallback? onPressed]) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 24),
        decoration: BoxDecoration(
          color: color, // Set your custom background color here
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 6),
            Text(label,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'LeagueSpartan',
                )),
          ],
        ),
      ),
    );
  }
}
