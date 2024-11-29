import 'package:camp_organizer/presentation/notification/notification.dart';
import 'package:camp_organizer/widgets/Dropdown/custom_dropdown.dart';
import 'package:camp_organizer/widgets/Text%20Form%20Field/custom_text_form_field.dart';
import 'package:camp_organizer/widgets/button/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminAddEmployee extends StatefulWidget {
  const AdminAddEmployee({super.key});

  @override
  State<AdminAddEmployee> createState() => _AdminAddEmployeeState();
}

class _AdminAddEmployeeState extends State<AdminAddEmployee> {
  // Controllers for each input field
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController empCodeController = TextEditingController();
  final TextEditingController lane1Controller = TextEditingController();
  final TextEditingController lane2Controller = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController reEnterPasswordController =
      TextEditingController();

  final List<String> gender = ['Male', 'Female'];
  String? selectedValue;
  final List<String> role = [
    'CampOrganizer',
    'OnSiteManagement',
    'CampIncharge',
    'Accountant',
    'Logistics',
    'Followup',
  ];
  String? selectedrole;

  // Firebase Authentication and Firestore instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Date selection method
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        dobController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      });
    }
  }

  // Dispose controllers
  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    dobController.dispose();
    positionController.dispose();
    empCodeController.dispose();
    lane1Controller.dispose();
    lane2Controller.dispose();
    stateController.dispose();
    pinCodeController.dispose();
    passwordController.dispose();
    reEnterPasswordController.dispose();
    super.dispose();
  }

  // Function to handle user registration
  Future<void> _registerEmployee() async {
    if (passwordController.text != reEnterPasswordController.text) {
      _showSnackBar("Passwords do not match");
      return;
    }

    // Construct email from empCode
    String email = '${empCodeController.text}@gmail.com';

    try {
      // Register with Firebase Authentication using constructed email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: passwordController.text,
      );

      // Save employee data to Firestore
      await _firestore
          .collection('employees')
          .doc(userCredential.user?.uid)
          .set({
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'dob': dobController.text,
        'gender': selectedValue,
        'notification': positionController.text,
        'empCode': empCodeController.text,
        'email': email, // Use the constructed email
        'lane1': lane1Controller.text,
        'lane2': lane2Controller.text,
        'role': selectedrole,
        'state': stateController.text,
        'pinCode': pinCodeController.text,
        'password': passwordController.text,
      });

      // Show success snackbar
      _showSnackBar("Employee Registered Successfully!");
    } catch (e) {
      // Catch and display errors
      _showSnackBar("Error: ${e.toString()}");
    }
  }

  // Function to show snackbar messages
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'LeagueSpartan',
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green, // Green for success
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        duration: Duration(seconds: 3), // Visible for 3 seconds
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        title: const Text(
          'Employee Registration',
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
              colors: [Colors.blue, Colors.lightBlueAccent, Colors.lightBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Create Accounts',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'LeagueSpartan',
                ),
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      labelText: 'First Name',
                      controller: firstNameController,
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: CustomTextFormField(
                      labelText: 'Last Name',
                      controller: lastNameController,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: dobController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'D.O.B',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () => _selectDate(context),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: CustomDropdownFormField(
                      labelText: "Gender",
                      items: gender,
                      value: selectedValue,
                      onChanged: (newValue) {
                        setState(() {
                          selectedValue = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select an option';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              CustomDropdownFormField(
                labelText: "Role",
                items: role,
                value: selectedrole,
                onChanged: (newValue) {
                  setState(() {
                    selectedrole = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select an option';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              CustomTextFormField(
                labelText: 'Notification Email',
                controller: positionController,
              ),
              SizedBox(height: 30),
              CustomTextFormField(
                labelText: 'Employee Code',
                controller: empCodeController,
              ),
              SizedBox(height: 20),
              Text(
                'Communication Address',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              CustomTextFormField(
                labelText: 'Lane 1',
                controller: lane1Controller,
              ),
              SizedBox(height: 30),
              CustomTextFormField(
                labelText: 'Lane 2',
                controller: lane2Controller,
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      labelText: 'State',
                      controller: stateController,
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: CustomTextFormField(
                      labelText: 'PIN Code',
                      controller: pinCodeController,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Password',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              CustomTextFormField(
                labelText: 'Enter New Password',
                controller: passwordController,
                //     obscureText: true,
              ),
              SizedBox(height: 30),
              CustomTextFormField(
                labelText: 'Re Enter Password',
                controller: reEnterPasswordController,
                //  obscureText: true,
              ),
              SizedBox(height: 30),
              CustomButton(
                text: 'Create',
                onPressed: _registerEmployee,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
