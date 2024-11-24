import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/AddEvent/add_finance_bloc.dart';
import '../../../bloc/AddEvent/add_finance_event.dart';
import '../../../widgets/Text Form Field/custom_text_form_field.dart';
import '../../../widgets/button/custom_button.dart';
import '../../notification/notification.dart';

class FinanceAddExpense extends StatefulWidget {
  final String documentId;
  final Map<String, dynamic> campData;

  const FinanceAddExpense({Key? key, required this.documentId, required this.campData}) : super(key: key);

  @override
  State<FinanceAddExpense> createState() => _FinanceAddExpenseState();
}

class _FinanceAddExpenseState extends State<FinanceAddExpense> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Controllers for each input field
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController campNameController = TextEditingController();
  final TextEditingController organizationController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final TextEditingController otherExpensesController = TextEditingController();
  final TextEditingController vehicleExpensesController = TextEditingController();
  final TextEditingController staffSalaryController = TextEditingController();
  final TextEditingController otController = TextEditingController();
  final TextEditingController catController = TextEditingController();
  final TextEditingController gpPayingCaseController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  void submitExpenseData(BuildContext context, String documentId) {
    if (_formKey.currentState?.validate() ?? false) {
      final Map<String, dynamic> expenseData = {
        'date': dateController.text.trim(),
        'time': timeController.text.trim(),
        'campName': campNameController.text.trim(),
        'organization': organizationController.text.trim(),
        'place': placeController.text.trim(),
        'otherExpenses': otherExpensesController.text.trim(),
        'vehicleExpenses': vehicleExpensesController.text.trim(),
        'staffSalary': staffSalaryController.text.trim(),
        'ot': otController.text.trim(),
        'cat': catController.text.trim(),
        'gpPayingCase': gpPayingCaseController.text.trim(),
        'remarks': remarksController.text.trim(),
      };

      // Dispatch the data to the BLoC
      context.read<AddFinanceBloc>().add(AddFinanceWithDocumentId(documentId: widget.documentId, data: expenseData));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expense data submitted successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
    }
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    dateController.dispose();
    timeController.dispose();
    campNameController.dispose();
    organizationController.dispose();
    placeController.dispose();
    otherExpensesController.dispose();
    vehicleExpensesController.dispose();
    staffSalaryController.dispose();
    otController.dispose();
    catController.dispose();
    gpPayingCaseController.dispose();
    remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Camp Expenses',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
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
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        labelText: 'Date',
                        controller: dateController,
                        validator: (value) =>
                        value == null || value.isEmpty ? 'Enter date' : null,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: CustomTextFormField(
                        labelText: 'Time',
                        controller: timeController,
                        validator: (value) =>
                        value == null || value.isEmpty ? 'Enter time' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  labelText: 'Camp Name',
                  controller: campNameController,
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Enter camp name' : null,
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  labelText: 'Organization',
                  controller: organizationController,
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Enter organization' : null,
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  labelText: 'Place',
                  controller: placeController,
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Enter place' : null,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Camp Expenses',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  labelText: 'Other Expenses',
                  controller: otherExpensesController,
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  labelText: 'Vehicle Expenses',
                  controller: vehicleExpensesController,
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  labelText: 'Staff Salary',
                  controller: staffSalaryController,
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  labelText: 'OT X 750',
                  controller: otController,
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  labelText: 'CAT X 2000',
                  controller: catController,
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  labelText: 'GP Paying Case',
                  controller: gpPayingCaseController,
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  labelText: 'Remarks',
                  controller: remarksController,
                ),
                const SizedBox(height: 30),
                CustomButton(
                  text: 'Submit Expenses',
                  onPressed: () {
                    submitExpenseData(context, widget.documentId);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
