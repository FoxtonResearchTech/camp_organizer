import 'package:camp_organizer/widgets/Text%20Form%20Field/custom_text_form_field.dart';
import 'package:flutter/material.dart';

import '../../notification/notification.dart';
import 'manage_employee_account.dart';

class EditEmployeeAccount extends StatefulWidget {
  final Employee employee;
  final int index;
  final Function onUpdate;
  final Function onDelete;

  const EditEmployeeAccount({
    Key? key,
    required this.employee,
    required this.index,
    required this.onUpdate,
    required this.onDelete,
  }): super(key: key);

  @override
  State<EditEmployeeAccount> createState() => _EditEmployeeAccountState();
}



class _EditEmployeeAccountState extends State<EditEmployeeAccount> {
  late TextEditingController nameController;
  late TextEditingController empCodeController;
  late TextEditingController designationController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.employee.name);
    empCodeController = TextEditingController(text: widget.employee.empCode);
    designationController = TextEditingController(text: widget.employee.designation);
  }

  void _updateEmployee() {
    widget.onUpdate(
      widget.index,
      Employee(
        name: nameController.text,
        empCode: empCodeController.text,
        designation: designationController.text,
      ),
    );
    Navigator.pop(context);
  }

  void _deleteEmployee() {
    widget.onDelete(widget.index);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Update User Account',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextFormField(labelText: 'Name',controller: nameController,),
            SizedBox(height: 20,),
            CustomTextFormField(labelText: 'Employee Code', controller: empCodeController,),
            SizedBox(height: 20,),
            CustomTextFormField(labelText: 'Designation',controller: designationController,),
            const SizedBox(height: 30),


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCustomActionButton(Icons.update_outlined, "Update", Colors.green, _updateEmployee), // Use custom button
                _buildCustomActionButton(Icons.delete_outline_outlined, "Delete", Colors.red, _deleteEmployee,),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomActionButton(IconData icon, String label, Color color, [VoidCallback? onPressed]) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 24),
        decoration: BoxDecoration(
          color: color,  // Set your custom background color here
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
}
