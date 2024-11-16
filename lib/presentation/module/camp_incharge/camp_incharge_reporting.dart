import 'package:flutter/material.dart';

import '../../../widgets/Dropdown/custom_dropdown.dart';
import '../../../widgets/Text Form Field/custom_text_form_field.dart';
import '../../../widgets/button/custom_button.dart';
import '../../notification/notification.dart';

class CampInchargeReporting extends StatefulWidget {
  const CampInchargeReporting({super.key});

  @override
  State<CampInchargeReporting> createState() => _CampInchargeReportingState();
}

class _CampInchargeReportingState extends State<CampInchargeReporting> {
  final List<Widget> _patientFollowUpFields = [];

  void _addFollowUpField() {
    setState(() {
      _patientFollowUpFields.addAll([
        Row(
          children: [
            Expanded(
              child: CustomTextFormField(
                labelText: 'Name',
              ),
            ),
            SizedBox(width: 15), // Space between columns
            Expanded(
              child: CustomTextFormField(
                labelText: 'Phone Number',
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        CustomTextFormField(
          labelText: 'Status',

        ),
        SizedBox(height: 20), // Space between rows
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Camp Incharge Reporting',
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

              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      labelText: 'Date',

                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: CustomTextFormField(
                      labelText: 'Time',

                    ),
                  ),
                ],
              ),


              SizedBox(height: 20),
              CustomTextFormField(
                labelText: 'Camp Name',

              ),
              SizedBox(height: 20),
              CustomTextFormField(
                labelText: 'Organization',

              ),
              SizedBox(height: 20),
              CustomTextFormField(
                labelText: 'Place',

              ),
              SizedBox(height: 20),
              CustomTextFormField(
                labelText: 'Camp Organizer',

              ),
              SizedBox(height: 20),
              Text(
                'Camp Reports',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              CustomTextFormField(
                labelText: 'No of Patients Attended',

              ),
              SizedBox(height: 20),
              CustomTextFormField(
                labelText: 'Number of Catract Patient identified',

              ),


              SizedBox(height: 20),
              CustomTextFormField(
                labelText: 'Number of Patients Selected for Surgery',

                //     obscureText: true,
              ),
              SizedBox(height: 20),
              CustomTextFormField(
                labelText: 'Number of Diabetic Patients',

                //  obscureText: true,
              ),
              SizedBox(height: 20),
              CustomTextFormField(
                labelText: 'Number of Glasses Supplied',

                //  obscureText: true,
              ),
              SizedBox(height: 20),
              CustomTextFormField(
                labelText: 'Vehicle Number',

                //  obscureText: true,
              ),
              SizedBox(height: 20),
              CustomTextFormField(
                labelText: 'KM run',

                //  obscureText: true,
              ),
              SizedBox(height: 20),
              Text(
                'Patient Follow Up List',
                style: TextStyle(fontSize: 20),
              ),

              SizedBox(height: 30),
              ..._patientFollowUpFields,
              SizedBox(height: 20),
              CustomButton(
                text: ' + Add Patient',
                onPressed: _addFollowUpField,
              ),

              SizedBox(height: 30),
              CustomButton(
                text: 'Submit Report',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),

    );
  }
}
