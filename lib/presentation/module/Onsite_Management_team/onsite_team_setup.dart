import 'package:flutter/material.dart';

import '../../../widgets/Dropdown/custom_dropdown.dart';
import '../../../widgets/Text Form Field/custom_text_form_field.dart';
import '../../../widgets/button/custom_button.dart';
import '../../notification/notification.dart';

class OnsiteTeamSetup extends StatefulWidget {
  const OnsiteTeamSetup({super.key});

  @override
  State<OnsiteTeamSetup> createState() => _OnsiteTeamSetupState();
}

class _OnsiteTeamSetupState extends State<OnsiteTeamSetup> {

  final List<String> Opticals = ['Bejansingh_Opticals', 'SS_OPticals',];
  String? selectedopticals;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Onsite Team Setup',
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [

              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      labelText: 'Date',

                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: CustomTextFormField(
                      labelText: 'Time',

                    ),
                  ),
                ],
              ),


              SizedBox(height: 30),
              CustomTextFormField(
                labelText: 'Camp Name',

              ),
              SizedBox(height: 30),
              CustomTextFormField(
                labelText: 'Organization',

              ),
              SizedBox(height: 20),
              Text(
                'Team Info',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              CustomTextFormField(
                labelText: 'Doctor',

              ),
              SizedBox(height: 30),
              CustomTextFormField(
                labelText: 'Driver',

              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      labelText: 'Incharge',

                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: CustomTextFormField(
                      labelText: 'VN Reg',

                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),
              CustomTextFormField(
                labelText: 'AR',

                //     obscureText: true,
              ),
              SizedBox(height: 30),
              CustomTextFormField(
                labelText: 'Regnter',

                //  obscureText: true,
              ),
              SizedBox(height: 30),
              CustomTextFormField(
                labelText: 'Dr Room',

                //  obscureText: true,
              ),
              SizedBox(height: 30),
              CustomTextFormField(
                labelText: 'Counselling',

                //  obscureText: true,
              ),
              SizedBox(height: 30),
              CustomDropdownFormField(
                labelText: "Select Opticals",
                items: Opticals,
                value: selectedopticals,
                onChanged: (newValue) {
                  setState(() {
                    var selectedopticals = newValue;
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
              CustomButton(
                text: 'Setup',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),

    );
  }
}
