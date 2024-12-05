import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/AddEvent/onsite_add_team_bloc.dart';
import '../../../bloc/AddEvent/onsite_add_team_event.dart';
import '../../../bloc/AddEvent/onsite_add_team_state.dart';
import '../../../widgets/Dropdown/custom_dropdown.dart';
import '../../../widgets/Text Form Field/custom_text_form_field.dart';
import '../../../widgets/button/custom_button.dart';
import '../../notification/notification.dart';

class OnsiteTeamSetup extends StatefulWidget {
  final String documentId;
  final Map<String, dynamic> campData;

  const OnsiteTeamSetup(
      {Key? key, required this.documentId, required this.campData})
      : super(key: key);

  @override
  State<OnsiteTeamSetup> createState() => _OnsiteTeamSetupState();
}

class _OnsiteTeamSetupState extends State<OnsiteTeamSetup> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController campNameController = TextEditingController();
  final TextEditingController organizationController = TextEditingController();
  final TextEditingController doctorController = TextEditingController();
  final TextEditingController driverController = TextEditingController();
  final TextEditingController inchargeController = TextEditingController();
  final TextEditingController vnRegController = TextEditingController();
  final TextEditingController arController = TextEditingController();
  final TextEditingController regnterController = TextEditingController();
  final TextEditingController drRoomController = TextEditingController();
  final TextEditingController counsellingController = TextEditingController();
  final TextEditingController opticalIncharge1Controller = TextEditingController();
  final TextEditingController opticalIncharge2Controller = TextEditingController();

  final List<String> Opticals = [
    'Bejansingh_Opticals',
    'SS_OPticals',
  ];
  String? selectedOpticals;

  void saveData(BuildContext context, documentId) {
    final Map<String, dynamic> data = {
      // 'date': dateController.text.trim(),
      // 'time': timeController.text.trim(),
      // 'campName': campNameController.text.trim(),
      //  'organization': organizationController.text.trim(),
      'opticalIncharge1':opticalIncharge1Controller.text.trim(),
      'opticalIncharge2':opticalIncharge2Controller.text.trim(),
      'doctor': doctorController.text.trim(),
      'driver': driverController.text.trim(),
      'incharge': selectedEmployee,
      'vnReg': vnRegController.text.trim(),
      'ar': arController.text.trim(),
      'regnter': regnterController.text.trim(),
      'drRoom': drRoomController.text.trim(),
      'counselling': counsellingController.text.trim(),
      'optical': selectedOpticals,
    };

    context
        .read<AddTeamBloc>()
        .add(AddTeamWithDocumentId(documentId: widget.documentId, data: data));
  }

  String? selectedEmployee;
  List<String> employeeNames = [];

  @override
  void initState() {
    fetchEmployees();
    super.initState();
    // Initialize text controllers with data passed to the page
    dateController.text = widget.campData['campDate'] ?? ''; // if no value, set empty string
    timeController.text = widget.campData['campTime'] ?? '';
    doctorController.text = widget.campData['doctor'] ?? '';
    driverController.text = widget.campData['driver'] ?? '';
    inchargeController.text = widget.campData['incharge'] ?? '';
    vnRegController.text = widget.campData['vnReg'] ?? '';
    arController.text = widget.campData['ar'] ?? '';
    regnterController.text = widget.campData['regnter'] ?? '';
    drRoomController.text = widget.campData['drRoom'] ?? '';
    counsellingController.text = widget.campData['counselling'] ?? '';
    //selectedOpticals = widget.campData['optical']; // If available
    //selectedEmployee = widget.campData['incharge'];
    opticalIncharge2Controller.text = widget.campData['opticalIncharge2']?? '';
    opticalIncharge1Controller.text = widget.campData['opticalIncharge1']?? '';
  }

  @override
  void dispose() {
    // Dispose all controllers to free memory
    dateController.dispose();
    timeController.dispose();
    campNameController.dispose();
    organizationController.dispose();
    doctorController.dispose();
    driverController.dispose();
    inchargeController.dispose();
    vnRegController.dispose();
    arController.dispose();
    regnterController.dispose();
    drRoomController.dispose();
    counsellingController.dispose();
    opticalIncharge1Controller.dispose();
    opticalIncharge2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddTeamBloc(firestore: FirebaseFirestore.instance),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
          title: const Text(
            'Onsite Team Setup',
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
                colors: [ Color(0xFF0097b2),  Color(0xFF0097b2).withOpacity(1), Color(0xFF0097b2).withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          actions: [],
        ),
        body: BlocListener<AddTeamBloc, AddTeamState>(
          listener: (context, state) {
            if (state is AddTeamSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Center(child: Text('Data saved successfully!')),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is AddTeamError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Center(child: Text('Error: ${state.message}')),
                  backgroundColor: Colors.red,
                ),
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
                  /*
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          labelText: 'Date',
                          controller: dateController,
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: CustomTextFormField(
                          labelText: 'Time',
                          controller: timeController,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  CustomTextFormField(
                    labelText: 'Camp Name',
                    controller: campNameController,
                  ),
                  SizedBox(height: 30),
                  CustomTextFormField(
                    labelText: 'Organization',
                    controller: organizationController,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Team Info',
                    style: TextStyle(fontSize: 20),
                  ),
                 */
                  SizedBox(height: 20),
                  CustomTextFormField(
                    labelText: 'Doctor',
                    controller: doctorController,
                  ),
                  SizedBox(height: 30),
                  CustomTextFormField(
                    labelText: 'Driver',
                    controller: driverController,
                  ),
                  SizedBox(height: 30),
                  CustomDropdownFormField(
                    labelText: "Camp Incharge",
                    icon: Icons.person_pin,
                    items: employeeNames,
                    value: selectedEmployee,
                    onChanged: (newValue) {
                      setState(() {
                        selectedEmployee = newValue;
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
                  SizedBox(width: 20),
                  CustomTextFormField(
                    labelText: 'VN Reference',
                    controller: vnRegController,
                  ),
                  SizedBox(height: 20),
                  CustomTextFormField(
                    labelText: 'AR',
                    controller: arController,
                    //     obscureText: true,
                  ),
                  SizedBox(height: 30),
                  CustomTextFormField(
                    labelText: 'Register',
                    controller: regnterController,
                    //  obscureText: true,
                  ),
                  SizedBox(height: 30),
                  CustomTextFormField(
                    labelText: 'Dr Room',
                    controller: drRoomController,
                    //  obscureText: true,
                  ),
                  SizedBox(height: 30),
                  CustomTextFormField(
                    labelText: 'Counselling',
                    controller: counsellingController,
                    //  obscureText: true,
                  ),
                  SizedBox(height: 30),

                  CustomTextFormField(
                    labelText: 'Optical Incharge-1',
                    controller: opticalIncharge1Controller,
                    //  obscureText: true,
                  ),
                  SizedBox(height: 30),
                  CustomTextFormField(
                    labelText: 'Optical Incharge-2',
                    controller: opticalIncharge2Controller,
                    //  obscureText: true,
                  ),
                  /*CustomDropdownFormField(
                    labelText: "Select Opticals",
                    items: Opticals,
                    value: selectedOpticals,
                    onChanged: (newValue) {
                      setState(() {
                         selectedOpticals = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select an option';
                      }
                      return null;
                    },
                  ),*/
                  SizedBox(height: 30),
                  CustomButton(
                    text: 'Setup',
                    onPressed: () => saveData(context, widget.documentId),
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
          fontFamily: 'LeagueSpartan',
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
            Color(0xff0097b2),
            Color(0xff0097b2).withOpacity(0.5)!,
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
            fontFamily: 'LeagueSpartan',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          value?.toString() ?? 'N/A',
          style: const TextStyle(
            color: Colors.white,fontWeight: FontWeight.bold,
            fontFamily: 'LeagueSpartan',
          ),
        ),
      ),
    );
  }

  Future<void> fetchEmployees() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('employees')
          .where('role', isEqualTo: 'CampIncharge') // Filter by role
          .get();

      List<String> names = querySnapshot.docs
          .map((doc) => doc['firstName'] as String) // Extract names
          .toList();

      setState(() {
        employeeNames = names; // Update the list
      });
    } catch (e) {
      print('Error fetching employees: $e');
    }
  }
}
