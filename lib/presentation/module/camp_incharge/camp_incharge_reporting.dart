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

  const CampInchargeReporting(
      {super.key, required this.documentId, required this.campData});

  @override
  State<CampInchargeReporting> createState() => _CampInchargeReportingState();
}

class _CampInchargeReportingState extends State<CampInchargeReporting> {
  @override
  void initState() {
    print("Emp id:${widget.documentId.toString()}");
    print("Camp id:${widget.campData.toString()}");
    //getEmployeeDocId(widget.campData);
    // TODO: implement initState
    super.initState();
  }

  // TextEditingControllers for the form fields
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _campNameController = TextEditingController();
  final TextEditingController _organizationController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _campOrganizerController =
      TextEditingController();
  final TextEditingController _patientsAttendedController =
      TextEditingController();
  final TextEditingController _cataractPatientsController =
      TextEditingController();
  final TextEditingController _patientsSelectedForSurgeryController =
      TextEditingController();
  final TextEditingController _diabeticPatientsController =
      TextEditingController();
  final TextEditingController _glassesSuppliedController =
      TextEditingController();
  final TextEditingController _vehicleNumberController =
      TextEditingController();
  final TextEditingController _kmRunController = TextEditingController();

  final List<Widget> _patientFollowUpFields = [];
  List<Map<String, TextEditingController>> _followUpControllers = [];

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
      _patientFollowUpFields.addAll([
        Row(
          children: [
            Expanded(
              child: CustomTextFormField(
                controller: nameController,
                labelText: 'Name',
              ),
            ),
            SizedBox(width: 15), // Space between columns
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
        SizedBox(height: 20), // Space between rows
      ]);
    });
  }

  void submitReport(
      BuildContext context, String documentId, Map<String, dynamic> formData) {
    context.read<InchargeReportBloc>().add(
          UpdateInchargeReport(
            documentId: documentId,
            data: formData,
          ),
        );
  }

  void getEmployeeDocId(Map<String, dynamic> campData) {
    // Access the 'EmployeeDocId' or 'employeeDocId' field from the map
    String? employeeDocId =
        campData['employeeDocId'] ?? campData['employeeDocId'];

    if (employeeDocId != null) {
      print('Employee Document ID: $employeeDocId');
      saveFollowUpsToEmployeeCamp(
          employeeDocId, widget.documentId, _followUpControllers);
    } else {
      print('Employee Document ID not found.');
    }
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
                      _buildInfoCard(
                          'Organization', widget.campData['organization']),
                    ],
                  ),
                  _buildAnimatedSection(
                    context,
                    sectionTitle: 'Add Team Info',
                    children: [],
                  ),
                  SizedBox(height: 20),
                  CustomTextFormField(
                    labelText: 'Place',
                    controller: _placeController,
                  ),
                  SizedBox(height: 20),
                  CustomTextFormField(
                    labelText: 'Camp Organizer',
                    controller: _campOrganizerController,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Camp Reports',
                    style: TextStyle(fontSize: 20),
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
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(Icons.check_circle_outline,
                                  color: Colors.white),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Report Submited successfully!',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          duration: Duration(seconds: 3),
                        ),
                      );
                      final formData = {
                        'campName': _campNameController.text,
                        'organization': _organizationController.text,
                        'place': _placeController.text,
                        'campOrganizer': _campOrganizerController.text,
                        'patientsAttended':
                            int.tryParse(_patientsAttendedController.text) ?? 0,
                        'cataractPatients':
                            int.tryParse(_cataractPatientsController.text) ?? 0,
                        'patientsSelectedForSurgery': int.tryParse(
                                _patientsSelectedForSurgeryController.text) ??
                            0,
                        'diabeticPatients':
                            int.tryParse(_diabeticPatientsController.text) ?? 0,
                        'glassesSupplied':
                            int.tryParse(_glassesSuppliedController.text) ?? 0,
                        'vehicleNumber': _vehicleNumberController.text,
                        'kmRun': double.tryParse(_kmRunController.text) ?? 0.0,
                        'patientFollowUps':
                            _followUpControllers.map((controllerMap) {
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
                      //   getEmployeeDocId(widget.campData);
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

  Future<void> saveFollowUpsToEmployeeCamp(String employeeId, String campDocId,
      List<Map<String, TextEditingController?>> followUpControllers) async {
    try {
      // Convert the controller data to a list of maps
      final patientFollowUps = followUpControllers.map((controllerMap) {
        return {
          'name': controllerMap['name']?.text ?? '',
          'phone': controllerMap['phone']?.text ?? '',
          'status': controllerMap['status']?.text ?? '',
        };
      }).toList();

      // Reference the specific camp document in the 'camps' subcollection
      DocumentReference campDocRef = FirebaseFirestore.instance
          .collection('employees') // Main collection
          .doc(employeeId) // Employee document
          .collection('camps') // Subcollection
          .doc(campDocId); // Specific camp document

      // Set the follow-up data in the specified camp document
      await campDocRef.set({'followUps': patientFollowUps});

      print(
          'Follow-ups added successfully to Firestore with camp ID: $campDocId!');
    } catch (e) {
      print('Error adding follow-ups to Firestore: $e');
    }
  }
}
