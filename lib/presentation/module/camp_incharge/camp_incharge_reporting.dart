import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/AddEvent/incharge_report_bloc.dart';
import '../../../bloc/AddEvent/incharge_report_event.dart';
import '../../../bloc/AddEvent/incharge_report_state.dart';
import '../../../widgets/Dropdown/custom_dropdown.dart';
import '../../../widgets/Text Form Field/custom_text_form_field.dart';
import '../../../widgets/button/custom_button.dart';
import '../../notification/notification.dart';

class CampInchargeReporting extends StatefulWidget {
  final String documentId;
  final Map<String, dynamic> campData;

  const CampInchargeReporting({super.key, required this.documentId, required this.campData});

  @override
  State<CampInchargeReporting> createState() => _CampInchargeReportingState();
}

class _CampInchargeReportingState extends State<CampInchargeReporting> {

  // TextEditingControllers for the form fields
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _campNameController = TextEditingController();
  final TextEditingController _organizationController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _campOrganizerController = TextEditingController();
  final TextEditingController _patientsAttendedController = TextEditingController();
  final TextEditingController _cataractPatientsController = TextEditingController();
  final TextEditingController _patientsSelectedForSurgeryController = TextEditingController();
  final TextEditingController _diabeticPatientsController = TextEditingController();
  final TextEditingController _glassesSuppliedController = TextEditingController();
  final TextEditingController _vehicleNumberController = TextEditingController();
  final TextEditingController _kmRunController = TextEditingController();

  final List<Widget> _patientFollowUpFields = [];
  List<Map<String, TextEditingController>> _followUpControllers = [];

  @override
  void initState() {
    super.initState();
    // Initialize all fields with existing data if available
    _dateController.text = widget.campData['campDate'] ?? '';
    _timeController.text = widget.campData['campTime'] ?? '';
    _campNameController.text = widget.campData['campName'] ?? '';
    _organizationController.text = widget.campData['organization'] ?? '';
    _placeController.text = widget.campData['place'] ?? '';
    _campOrganizerController.text = widget.campData['campOrganizer'] ?? '';
    _patientsAttendedController.text = (widget.campData['patientsAttended'] ?? '').toString();
    _cataractPatientsController.text = (widget.campData['cataractPatients'] ?? '').toString();
    _patientsSelectedForSurgeryController.text = (widget.campData['patientsSelectedForSurgery'] ?? '').toString();
    _diabeticPatientsController.text = (widget.campData['diabeticPatients'] ?? '').toString();
    _glassesSuppliedController.text = (widget.campData['glassesSupplied'] ?? '').toString();
    _vehicleNumberController.text = widget.campData['vehicleNumber'] ?? '';
    _kmRunController.text = (widget.campData['kmRun'] ?? '').toString();
    // Initialize follow-up fields with existing data
    if (widget.campData['patientFollowUps'] != null) {
      for (var followUp in widget.campData['patientFollowUps']) {
        TextEditingController nameController = TextEditingController(text: followUp['name']);
        TextEditingController phoneController = TextEditingController(text: followUp['phone']);
        TextEditingController statusController = TextEditingController(text: followUp['status']);

        // Add controllers to the list
        _followUpControllers.add({
          'name': nameController,
          'phone': phoneController,
          'status': statusController,
        });

        // Add widgets for these fields
        _patientFollowUpFields.addAll([
          Row(
            children: [
              Expanded(
                child: CustomTextFormField(
                  controller: nameController,
                  labelText: 'Name',
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: CustomTextFormField(
                  controller: phoneController,
                  labelText: 'Phone Number',
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          CustomTextFormField(
            controller: statusController,
            labelText: 'Status',
          ),
          SizedBox(height: 20),
        ]);
      }
    }
  }

  void _addFollowUpField() {
    setState(() {
      // Create new controllers for this set of fields
      TextEditingController nameController = TextEditingController();
      TextEditingController phoneController = TextEditingController();
      TextEditingController statusController = TextEditingController();

      // Add controllers to the list
      _followUpControllers.add({
        'name': nameController,
        'phone': phoneController,
        'status': statusController,
      });

      // Add new widgets to the follow-up list
      _patientFollowUpFields.addAll([
        Row(
          children: [
            Expanded(
              child: CustomTextFormField(
                controller: nameController,
                labelText: 'Name',
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: CustomTextFormField(
                controller: phoneController,
                labelText: 'Phone Number',
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        CustomTextFormField(
          controller: statusController,
          labelText: 'Status',
        ),
        SizedBox(height: 20),
      ]);
    });
  }

  void submitReport(BuildContext context, String documentId, Map<String, dynamic> formData) {
    context.read<InchargeReportBloc>().add(
      UpdateInchargeReport(
        documentId: documentId,
        data: formData,
      ),
    );
  }


  @override
  void dispose() {
    // Dispose the controllers to prevent memory leaks
    _dateController.dispose();
    _timeController.dispose();
    _campNameController.dispose();
    _organizationController.dispose();
    _placeController.dispose();
    _campOrganizerController.dispose();
    _patientsAttendedController.dispose();
    _cataractPatientsController.dispose();
    _patientsSelectedForSurgeryController.dispose();
    _diabeticPatientsController.dispose();
    _glassesSuppliedController.dispose();
    _vehicleNumberController.dispose();
    _kmRunController.dispose();
    for (var controllerMap in _followUpControllers) {
      controllerMap['name']?.dispose();
      controllerMap['phone']?.dispose();
      controllerMap['status']?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InchargeReportBloc(firestore: FirebaseFirestore.instance),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios,color: Colors.white,)),
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

        ),
        body: BlocListener<InchargeReportBloc, InchargeReportState>(
          listener: (context, state) {
            if (state is InchargeReportUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Report Submitted Successfully!')),
              );
            } else if (state is InchargeReportError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.message}')),
              );
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [

                  _buildAnimatedSection(
                    context,
                    sectionTitle: 'Camp Info',
                    children: [
                      _buildInfoCard('Camp Name', widget.campData['campName']),
                      _buildInfoCard('Status', widget.campData['campStatus']),
                      _buildInfoCard('Date', widget.campData['campDate']),
                      _buildInfoCard('Time', widget.campData['campTime']),
                      _buildInfoCard('Organization', widget.campData['organization']),
                    ],
                  ),


                  SizedBox(height: 20),
                  Text(
                    'Camp Reports',
                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 20),
                  CustomTextFormField(
                    labelText: 'No of Patients Attended',
                    controller: _patientsAttendedController,
                  ),
                  SizedBox(height: 20),
                  CustomTextFormField(
                    labelText: 'Number of Catract Patient identified',
                    controller: _cataractPatientsController,
                  ),

                  SizedBox(height: 20),
                  CustomTextFormField(
                    labelText: 'Number of Patients Selected for Surgery',
                    controller: _patientsSelectedForSurgeryController,
                    //     obscureText: true,
                  ),
                  SizedBox(height: 20),
                  CustomTextFormField(
                    labelText: 'Number of Diabetic Patients',
                    controller: _diabeticPatientsController,
                    //  obscureText: true,
                  ),
                  SizedBox(height: 20),
                  CustomTextFormField(
                    labelText: 'Number of Glasses Supplied',
                    controller: _glassesSuppliedController,
                    //  obscureText: true,
                  ),
                  SizedBox(height: 20),
                  CustomTextFormField(
                    labelText: 'Vehicle Number',
                    controller: _vehicleNumberController,
                    //  obscureText: true,
                  ),
                  SizedBox(height: 20),
                  CustomTextFormField(
                    labelText: 'KM run',
                    controller: _kmRunController,
                    //  obscureText: true,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Patient Follow Up List',
                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),
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
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.white, size: 24), // Add an icon
                              SizedBox(width: 10), // Add spacing
                              Expanded(
                                child: Text(
                                  'Data Submited Successfully...!',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          backgroundColor: Colors.green, // Set green background color
                          behavior: SnackBarBehavior.floating, // Make it floating
                          margin: EdgeInsets.all(16), // Add margin for a floating SnackBar
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12), // Rounded corners
                          ),
                          duration: Duration(seconds: 3), // Set duration
                        ),
                      );

                      final formData = {
                        'patientsAttended': int.tryParse(_patientsAttendedController.text) ?? 0,
                        'cataractPatients': int.tryParse(_cataractPatientsController.text) ?? 0,
                        'patientsSelectedForSurgery': int.tryParse(_patientsSelectedForSurgeryController.text) ?? 0,
                        'diabeticPatients': int.tryParse(_diabeticPatientsController.text) ?? 0,
                        'glassesSupplied': int.tryParse(_glassesSuppliedController.text) ?? 0,
                        'vehicleNumber': _vehicleNumberController.text,
                        'kmRun': double.tryParse(_kmRunController.text) ?? 0.0,
                        'patientFollowUps': _followUpControllers.map((controllerMap) {
                          return {
                            'name': controllerMap['name']?.text ?? '',
                            'phone': controllerMap['phone']?.text ?? '',
                            'status': controllerMap['status']?.text ?? '',
                          };
                        }).toList(),

                      };

                      // Dispatch the event with form data
                      //context.read<InchargeReportBloc>().add(
                      //UpdateInchargeReport(
                      //  documentId: widget.documentId,
                      //  data: formData,
                      //),
                      //);
                      submitReport(context, widget.documentId, formData);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),

      ),
    );
  }

  // Helper method to build section titles with animation
  Widget _buildAnimatedSection(BuildContext context,
      {required String sectionTitle, required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 500),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: _buildSectionTitle(sectionTitle),
                ),
              );
            },
          ),
          ...children.map(
                (child) => TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 300),
              builder: (context, value, _) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: child,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build section titles
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.lightBlue[800],
        ),
      ),
    );
  }

  // Helper method to build information cards
  Widget _buildInfoCard(String label, dynamic value) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 7.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.cyan[100]!,
              Colors.cyan[50]!,
            ],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.cyan[200]!.withOpacity(0.5),
              blurRadius: 5,
              offset: const Offset(2, 3),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
          title: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          subtitle: Text(
            value?.toString() ?? 'N/A',
            style: const TextStyle(color: Colors.black54),
          ),
        ),
        );
    }

}