import 'package:camp_organizer/presentation/notification/notification.dart';
import 'package:camp_organizer/widgets/Dropdown/custom_dropdown.dart';
import 'package:camp_organizer/widgets/Text%20Form%20Field/custom_text_form_field.dart';
import 'package:camp_organizer/widgets/button/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminAddEmployee extends StatefulWidget {
  const AdminAddEmployee({super.key});

  @override
  State<AdminAddEmployee> createState() => _AdminAddEmployeeState();
}

class _AdminAddEmployeeState extends State<AdminAddEmployee> {
  TextEditingController dobController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        dobController.text = DateFormat('dd-MM-yyyy').format(pickedDate); // Format the selected date
      });
    }
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Create Accounts',style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), ),
              SizedBox(height: 30,),
              Row(
                children: [
                  Expanded(child: CustomTextFormField(labelText: 'First Name',),),
                  SizedBox(width: 20,),
                  Expanded(child: CustomTextFormField(labelText: 'Last Name',),),
                ],
              ),
              SizedBox(height: 30,),
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
                          onPressed: () => _selectDate(context), // Show DatePicker on press
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20,),
                  Expanded(child: CustomDropdownFormField(labelText: 'Gender',items: ['Male','Female'],),)

                ],
              ),
              SizedBox(height: 30,),
              Row(
                children: [
                  Expanded(child: CustomTextFormField(labelText: 'Position')),
                ],
              ),
              SizedBox(height: 30,),
              Row(
                children: [
                  Expanded(child: CustomTextFormField(labelText: 'Emp Code')),
                ],
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  SizedBox(width: 20,),
                  Expanded(child: Text('Communication Address',style: TextStyle(fontSize: 20),)),
                ],
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Expanded(child: CustomTextFormField(labelText: 'Lane 1')),
                ],
              ),
              SizedBox(height: 30,),
              Row(
                children: [
                  Expanded(child: CustomTextFormField(labelText: 'Lane 2')),
                ],
              ),
              SizedBox(height: 30,),
              Row(
                children: [
                  Expanded(child: CustomTextFormField(labelText: 'State',),),
                  SizedBox(width: 20,),
                  Expanded(child: CustomTextFormField(labelText: 'PIN Code',),),
                ],
              ),
              SizedBox(height: 30,),
              Row(
                children: [
                  Expanded(child: CustomTextFormField(labelText: 'State')),
                ],
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  SizedBox(width: 20,),
                  Expanded(child: Text('Password',style: TextStyle(fontSize: 20),)),
                ],
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Expanded(child: CustomTextFormField(labelText: 'Enter New Password')),
                ],
              ),
              SizedBox(height: 30,),
              Row(
                children: [
                  Expanded(child: CustomTextFormField(labelText: 'Re Enter Password')),
                ],
              ),
              SizedBox(height: 30,),
              Row(
                children: [
                  Expanded(child: CustomButton(text: 'Create', onPressed: () {})),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
