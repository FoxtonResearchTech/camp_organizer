import 'package:flutter/cupertino.dart';
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

  const FinanceAddExpense(
      {Key? key, required this.documentId, required this.campData})
      : super(key: key);

  @override
  State<FinanceAddExpense> createState() => _FinanceAddExpenseState();
}

class _FinanceAddExpenseState extends State<FinanceAddExpense> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Controllers for each input field

  final TextEditingController otherExpensesController = TextEditingController();
  final TextEditingController vehicleExpensesController = TextEditingController();
  final TextEditingController staffSalaryController = TextEditingController();
  final TextEditingController otController = TextEditingController();
  final TextEditingController catController = TextEditingController();
  final TextEditingController gpPayingCaseController = TextEditingController();
  final TextEditingController expenseremarksController = TextEditingController();
  final TextEditingController incomeremarksController = TextEditingController();
  final TextEditingController glassesTakenController = TextEditingController();
  final TextEditingController glassesSoldController = TextEditingController();
  final TextEditingController glassAmountController = TextEditingController();
  final TextEditingController glassesReturnController = TextEditingController();
  final TextEditingController glassremarksController = TextEditingController();

  void submitExpenseData(BuildContext context, String documentId) {
    if (_formKey.currentState?.validate() ?? false) {
      final Map<String, dynamic> expenseData = {
        'otherExpenses': otherExpensesController.text.trim(),
        'vehicleExpenses': vehicleExpensesController.text.trim(),
        'staffSalary': staffSalaryController.text.trim(),
        'ot': otController.text.trim(),
        'cat': catController.text.trim(),
        'gpPayingCase': gpPayingCaseController.text.trim(),
        'expenseRemarks': expenseremarksController.text.trim(),
        'incomeRemarks':incomeremarksController.text.trim(),
        'glassesTaken':glassesTakenController.text.trim(),
        'glassesSold':glassesSoldController.text.trim(),
        'glassAmount':glassAmountController.text.trim(),
        'glassesReturn':glassesReturnController.text.trim(),
        'glassremarks':glassremarksController.text.trim(),
      };

      // Dispatch the data to the BLoC
      context.read<AddFinanceBloc>().add(AddFinanceWithDocumentId(
          documentId: widget.documentId, data: expenseData));

      //ScaffoldMessenger.of(context).showSnackBar(
        //const SnackBar(
        //  content: Center(child: Text('Expense data submitted successfully')),
        //  backgroundColor: Colors.green,
        //),
      //);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text('Please fill all required fields')),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    final data = widget.campData;

    otherExpensesController.text = widget.campData['otherExpenses'] ?? '';
    vehicleExpensesController.text = widget.campData['vehicleExpenses'] ?? '';
    staffSalaryController.text = widget.campData['staffSalary'] ?? '';
    otController.text = widget.campData['ot'] ?? '';
    catController.text = widget.campData['cat'] ?? '';
    gpPayingCaseController.text = widget.campData['gpPayingCase'] ?? '';
    expenseremarksController.text = widget.campData['expenseRemarks'] ?? '';
    incomeremarksController.text = widget.campData['incomeRemarks'] ?? '';
    glassesTakenController.text = widget.campData['glassesTaken'] ?? '';
    glassesSoldController.text = widget.campData['glassesSold'] ?? '';
    glassAmountController.text = widget.campData['glassAmount'] ?? '';
    glassesReturnController.text = widget.campData['glassesReturn'] ?? '';
    glassremarksController.text = widget.campData['glassremarks'] ?? '';
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    otherExpensesController.dispose();
    vehicleExpensesController.dispose();
    staffSalaryController.dispose();
    otController.dispose();
    catController.dispose();
    gpPayingCaseController.dispose();
    expenseremarksController.dispose();
    incomeremarksController.dispose();
    glassesTakenController.dispose();
    glassesSoldController.dispose();
    glassAmountController.dispose();
    glassesReturnController.dispose();
    glassremarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Camp Income & Expenses',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'LeagueSpartan',
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
              colors: [ Color(0xFF0097b2),  Color(0xFF0097b2).withOpacity(1), Color(0xFF0097b2).withOpacity(0.8)],
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Camp Expenses',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'LeagueSpartan',
                  ),
                ),
                const SizedBox(height: 20),

                CustomTextFormField(
                  labelText: 'Vehicle Expenses',
                  controller: vehicleExpensesController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  labelText: 'Staff Salary',
                  controller: staffSalaryController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),

                CustomTextFormField(
                  labelText: 'Other Expenses',
                  controller: otherExpensesController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  labelText: 'Remarks',
                  controller: expenseremarksController,
                ),
                const SizedBox(height: 30),
                const Text(
                  'Camp Income',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'LeagueSpartan',
                  ),
                ),
                const SizedBox(height: 20,),
                CustomTextFormField(
                  labelText: 'OT X 750',
                  controller: otController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  labelText: 'CAT X 2000',
                  controller: catController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  labelText: 'GP Paying Case',
                  controller: gpPayingCaseController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  labelText: 'Remarks',
                  controller: incomeremarksController,
                ),
                const SizedBox(height: 20,),
                const Text(
                  'Opticals Info',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'LeagueSpartan',
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  labelText: 'Number of Glasses Taken',
                  controller: glassesTakenController,
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  labelText: 'Number of Glasses Sold',
                  controller: glassesSoldController,
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  labelText: 'Amount Collected',
                  controller: glassAmountController,
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  labelText: 'Number of Glasses Return',
                  controller: glassesReturnController,
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  labelText: 'Remarks',
                  controller: glassremarksController,
                ),
                const SizedBox(height: 20,),
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
