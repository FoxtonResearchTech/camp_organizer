import 'package:camp_organizer/widgets/button/custom_button.dart';
import 'package:flutter/material.dart';

import '../../../widgets/Text Form Field/custom_text_form_field.dart';
import '../../notification/notification.dart';

class PostCampFollow extends StatefulWidget {
  const PostCampFollow({super.key});

  @override
  State<PostCampFollow> createState() => _PostCampFollowState();
}

class _PostCampFollowState extends State<PostCampFollow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Post Camp Follow UP',
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
              SizedBox(height: 30,),
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
              SizedBox(height: 20),

              Text(
                'Patient Data',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              CustomTextFormField(
                labelText: '',

              ),
              SizedBox(height: 20),
              CustomTextFormField(
                labelText: 'Remarks',

              ),
              SizedBox(height: 20,),
              CustomButton(text: 'Submit', onPressed: () {}),
            ],

          ),
        ),

      ),



    );
  }
}
