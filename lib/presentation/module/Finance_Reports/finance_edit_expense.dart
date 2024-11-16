import 'package:flutter/material.dart';

import '../../../widgets/Text Form Field/custom_text_form_field.dart';
import '../../../widgets/button/custom_button.dart';
import '../../notification/notification.dart';

class FinanceEditExpense extends StatefulWidget {
  const FinanceEditExpense({super.key});

  @override
  State<FinanceEditExpense> createState() => _FinanceEditExpenseState();
}

class _FinanceEditExpenseState extends State<FinanceEditExpense> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Camp Edit Expenses',
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
              Text(
                'Camp Expenses',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              CustomTextFormField(
                labelText: 'Other Expenses',

              ),
              SizedBox(height: 20),
              CustomTextFormField(
                labelText: 'Vehicle Expenses',

              ),


              SizedBox(height: 20),
              CustomTextFormField(
                labelText: 'Staff Salary',

                //     obscureText: true,
              ),
              SizedBox(height: 20),
              CustomTextFormField(
                labelText: 'OT X 750',

                //  obscureText: true,
              ),
              SizedBox(height: 20),
              CustomTextFormField(
                labelText: 'CAT X 2000',

                //  obscureText: true,
              ),
              SizedBox(height: 20),
              CustomTextFormField(
                labelText: 'GP Paying Case',

                //  obscureText: true,
              ),
              SizedBox(height: 20),
              CustomTextFormField(
                labelText: 'Remarks',

                //  obscureText: true,
              ),



              SizedBox(height: 30),
              CustomButton(
                text: 'Submit Expenses',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
