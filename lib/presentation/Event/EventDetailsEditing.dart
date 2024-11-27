import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../widgets/Dropdown/custom_dropdown.dart';
import '../../widgets/Text Form Field/custom_text_form_field.dart';

class EventDetailsEditing extends StatefulWidget {
  final Map<String, dynamic> employee;
  final DocumentReference docRef;
  String? campId;
  EventDetailsEditing(
      {required this.employee, required this.docRef, this.campId});

  @override
  _EventDetailsEditingState createState() => _EventDetailsEditingState();
}

class _EventDetailsEditingState extends State<EventDetailsEditing>
    with SingleTickerProviderStateMixin {
  late TextEditingController _dateController;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isEditing = true;
  late Map<String, dynamic> _editableEmployee;
  final List<String> dropdownItems = ['Morning', 'Afternoon'];
  final List<String> campPlanType = [
    'Main Event With Co-organized',
    'Individual Campevent'
  ];
  final List<String> lastCampDone = [
    'below 1 month',
    '1 month above',
    '2 month above',
    '3 month above',
    '6 month above',
    '12 month above',
    '2 years above',
    '5 years above'
  ];

  String? selectedValue;
  String? campPlanselectedValue;
  String? lastselectedValue;
  final List<String> _options = ['Yes', 'No'];
  String? _selectedValue;
  String? _selectedValue2;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
    _editableEmployee = Map<String, dynamic>.from(widget.employee);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: const Offset(0, 0))
            .animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
    populateData();
  }

  Future<void> populateData() async {
    try {
      print(widget.employee);
      setState(() {
        // Populate fields
        _dateController.text = widget.employee['campDate'] ?? '';
        timeController.text = widget.employee['campTime'] ?? '';
        campNameController.text = widget.employee['campName'] ?? '';
        organizationController.text = widget.employee['organization'] ?? '';
        addressController.text = widget.employee['address'] ?? '';
        cityController.text = widget.employee['city'] ?? '';
        stateController.text = widget.employee['state'] ?? '';
        pincodeController.text = widget.employee['pincode'] ?? '';
        nameController.text = widget.employee['name'] ?? '';
        positionController.text = widget.employee['position'] ?? '';
        phoneNumber1Controller.text = widget.employee['phoneNumber1'] ?? '';
        phoneNumber2Controller.text = widget.employee['phoneNumber1_2'] ?? '';
        name2Controller.text = widget.employee['name2'] ?? '';
        position2Controller.text = widget.employee['position2'] ?? '';
        phoneNumber1_2Controller.text = widget.employee['phoneNumber2_1'] ?? '';
        phoneNumber2_2Controller.text = widget.employee['phoneNumber2_2'] ?? '';
        totalSquareFeetController.text =
            widget.employee['totalSquareFeet'] ?? '';
        noOfPatientExpectedController.text =
            widget.employee['noOfPatientExpected'] ?? '';
        campPlanselectedValue = widget.employee['campPlanType'] ?? '';
        lastselectedValue = widget.employee['lastCampDone'] ?? '';
        _selectedValue = widget.employee['roadAccess'] ?? '';
        _selectedValue2 = widget.employee['waterAvailability'] ?? '';
      });
    } catch (e) {
      print("Error occured while Fetching $e");
    }
  }

  Future<void> deleteCamp() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final userId = user?.uid;

      if (userId != null && widget.campId != null) {
        await FirebaseFirestore.instance
            .collection('employees')
            .doc(userId)
            .collection('camps')
            .doc(widget.campId)
            .delete();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(child: Text("Camp deleted successfully")),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        throw Exception("Invalid user or camp ID");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            children: [
              Text("Error deleting camp: $e"),
            ],
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> updateDataToFirestore() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final userId = user?.uid;
      final campsSnapshot = await FirebaseFirestore.instance
          .collection('employees')
          .doc(userId)
          .collection('camps')
          .get();

      for (var doc in campsSnapshot.docs) {
        String documentId =
            doc.id; // Document ID of each document in the collection
        print('Document ID: $documentId');
        await FirebaseFirestore.instance
            .collection('employees')
            .doc(userId)
            .collection('camps')
            .doc(widget.campId)
            .update({
          'campDate': _dateController.text,
          'campTime': timeController.text,
          'campName': campNameController.text,
          'organization': organizationController.text,
          'address': addressController.text,
          'city': cityController.text,
          'state': stateController.text,
          'pincode': pincodeController.text,
          'name': nameController.text,
          'position': positionController.text,
          'phoneNumber1': phoneNumber1Controller.text,
          'phoneNumber1_2': phoneNumber2Controller.text,
          'name2': name2Controller.text,
          'position2': position2Controller.text,
          'phoneNumber2_1': phoneNumber1_2Controller.text,
          'phoneNumber2_2': phoneNumber2_2Controller.text,
          'totalSquareFeet': totalSquareFeetController.text,
          'noOfPatientExpected': noOfPatientExpectedController.text,
          'campPlanType': campPlanselectedValue,
          'lastCampDone': lastselectedValue,
          'roadAccess': _selectedValue,
          'waterAvailability': _selectedValue2,
        });

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Center(child: Text("Data updated successfully")),
          backgroundColor: Colors.green,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(child: Text("Error updating data: $e")),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    campNameController.dispose();
    organizationController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    pincodeController.dispose();
    nameController.dispose();
    phoneNumber1Controller.dispose();
    phoneNumber2Controller.dispose();
    name2Controller.dispose();
    phoneNumber1_2Controller.dispose();
    phoneNumber2_2Controller.dispose();
    totalSquareFeetController.dispose();
    noOfPatientExpectedController.dispose();
    _dateController.dispose();
    timeController.dispose();
    position2Controller.dispose();
    positionController.dispose();
    super.dispose();
  }

  TextEditingController timeController = TextEditingController();
  final TextEditingController campNameController = TextEditingController();
  final TextEditingController organizationController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumber1Controller = TextEditingController();
  final TextEditingController phoneNumber2Controller = TextEditingController();
  final TextEditingController name2Controller = TextEditingController();
  final TextEditingController phoneNumber1_2Controller =
      TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController position2Controller = TextEditingController();
  final TextEditingController phoneNumber2_2Controller =
      TextEditingController();
  final TextEditingController totalSquareFeetController =
      TextEditingController();
  final TextEditingController noOfPatientExpectedController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Camp Details',
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlueAccent, Colors.lightBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              bool? confirmDelete = await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Delete Camp'),
                    content: const Text(
                        'Are you sure you want to delete this camp?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel',
                            style: TextStyle(color: AppColors.accentBlue)),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Delete',
                            style: TextStyle(color: AppColors.accentBlue)),
                      ),
                    ],
                  );
                },
              );

              if (confirmDelete == true) {
                await deleteCamp();
              }
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    child: CustomTextFormField(
                      controller: _dateController,
                      onTap: () => _selectDate(context),
                      labelText: 'Date',
                      icon: Icons.date_range,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    child: CustomTextFormField(
                      controller: timeController,
                      onTap: () async {
                        // Open the time picker when the TextField is tapped
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay
                              .now(), // Set the initial time to the current time
                        );

                        if (pickedTime != null) {
                          // Format and set the selected time in the TextField
                          timeController.text = pickedTime.format(context);
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a time';
                        }
                        return null;
                      },
                      labelText: 'Time',
                      icon: Icons.watch_later,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildCustomTextFormField(
                'Camp Name', Icons.location_city, campNameController),
            const SizedBox(height: 20),
            _buildCustomTextFormField(
                'Organization', Icons.location_city, organizationController),
            const SizedBox(height: 20),
            _buildCustomTextFormField('Address', Icons.home, addressController),
            const SizedBox(height: 20),
            _buildCustomTextFormField(
                'City', Icons.location_city, cityController),
            const SizedBox(height: 20),
            _buildCustomTextFormField(
                'State', Icons.location_city, stateController),
            const SizedBox(height: 20),
            _buildCustomTextFormField(
                'Pincode', Icons.location_city, pincodeController),
            const SizedBox(height: 20),
            const Text(
              "Concern Person1 Details",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
            ),
            const SizedBox(height: 20),
            _buildCustomTextFormField(
                'Name', Icons.location_city, nameController),
            const SizedBox(height: 20),
            _buildCustomTextFormField(
                'Position', Icons.location_city, positionController),
            // Assuming Position field is here
            const SizedBox(height: 20),
            _buildCustomTextFormField(
                'Phone Number 1', Icons.location_city, phoneNumber1Controller),
            const SizedBox(height: 20),
            _buildCustomTextFormField(
                'Phone Number 2', Icons.location_city, phoneNumber2Controller),
            const SizedBox(height: 20),
            const Text(
              "Concern Person2 Details",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
            ),
            const SizedBox(height: 20),
            _buildCustomTextFormField(
                'Name', Icons.location_city, name2Controller),
            const SizedBox(height: 20),
            _buildCustomTextFormField(
                'Position', Icons.location_city, position2Controller),
            const SizedBox(height: 20),
            _buildCustomTextFormField('Phone Number 1', Icons.location_city,
                phoneNumber1_2Controller),
            const SizedBox(height: 20),
            _buildCustomTextFormField('Phone Number 2', Icons.location_city,
                phoneNumber2_2Controller),
            const SizedBox(height: 20),
            const Text(
              "Event Planning",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
            ),
            const SizedBox(height: 20),
            CustomDropdownFormField(
              labelText: "Camp Plan Type",
              icon: Icons.campaign,
              items: campPlanType,
              value: campPlanselectedValue,
              onChanged: (newValue) {
                setState(() {
                  campPlanselectedValue = newValue;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select an option';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildRadioOption('Road Access Site:', _options, _selectedValue,
                (value) {
              setState(() {
                _selectedValue = value;
              });
            }),
            const SizedBox(height: 20),
            _buildCustomTextFormField('Total Square Feet',
                Icons.area_chart_outlined, totalSquareFeetController),
            const SizedBox(height: 20),
            _buildRadioOption('Water Availability:', _options, _selectedValue2,
                (value) {
              setState(() {
                _selectedValue2 = value;
              });
            }),
            const SizedBox(height: 20),
            _buildCustomTextFormField('No Of Patient Expected', Icons.person,
                noOfPatientExpectedController),
            const SizedBox(height: 20),
            CustomDropdownFormField(
              labelText: "Last Camp Done",
              icon: Icons.campaign_outlined,
              items: lastCampDone,
              value: lastselectedValue,
              onChanged: (newValue) {
                setState(() {
                  lastselectedValue = newValue;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select an option';
                }
                return null;
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              icon: Icon(_isEditing ? Icons.save : Icons.edit,
                  color: Colors.white),
              onPressed: () {
                updateDataToFirestore();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              label: Text(
                _isEditing ? "Save" : "Edit",
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomTextFormField(
      String label, IconData icon, TextEditingController controller) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      child: CustomTextFormField(
        labelText: label,
        controller: controller,
        icon: icon,
      ),
    );
  }

  Widget _buildRadioOption(String label, List<String> options,
      String? selectedValue, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        Row(
          children: options.map((option) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<String>(
                  value: option,
                  groupValue: selectedValue,
                  onChanged: onChanged,
                ),
                Text(option),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
