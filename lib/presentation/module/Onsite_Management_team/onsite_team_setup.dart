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
          actions: [],
        ),
        body: BlocListener<AddTeamBloc, AddTeamState>(
          listener: (context, state) {
            if (state is AddTeamSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data saved successfully!')),
              );
            } else if (state is AddTeamError) {
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
                    labelText: 'VN Reg',
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
                    labelText: 'Regnter',
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
                  CustomDropdownFormField(
                    labelText: "Select Opticals",
                    items: Opticals,
                    value: selectedOpticals,
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
