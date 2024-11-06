import 'package:camp_organizer/presentation/notification/notification.dart';
import 'package:camp_organizer/utils/app_colors.dart';
import 'package:camp_organizer/widgets/Dropdown/custom_dropdown.dart';
import 'package:camp_organizer/widgets/Text%20Form%20Field/custom_text_form_field.dart';
import 'package:camp_organizer/widgets/button/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({super.key});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> with SingleTickerProviderStateMixin {
  late TextEditingController _dateController;
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  final List<String> dropdownItems = ['Morning', 'Afternoon'];
  final List<String> campPlanType = ['Main Event With Co-organized', 'Individual Campevent'];
  final List<String> lastCampDone = ['below 1 month', '1 month above', '2 month above', '3 month above', '6 month above', '12 month above', '2 years above', '5 years above'];

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
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: const Offset(0.0, 0.1), end: Offset.zero).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.forward();
  }

  // Method to show the date picker
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
    _dateController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Event',
          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationPage()));
            },
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _opacityAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Event Details",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                  ),
                  SizedBox(height: 20),
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
                      SizedBox(width: 20),
                      Expanded(
                        child: AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          child: CustomDropdownFormField(
                            labelText: "Time",
                            icon: Icons.watch_later,
                            items: dropdownItems,
                            value: selectedValue,
                            onChanged: (newValue) {
                              setState(() {
                                selectedValue = newValue;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select an option';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ..._buildFormFields(), // Method to build the rest of the form fields
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormFields() {
    List<Widget> fields = [
      _buildCustomTextFormField('Camp Name', Icons.location_city),
      SizedBox(height: 20),
      _buildCustomTextFormField('Organization', Icons.location_city),
      SizedBox(height: 20),
      _buildCustomTextFormField('Address', Icons.home),
      SizedBox(height: 20),
      _buildCustomTextFormField('City', Icons.location_city),
      SizedBox(height: 20),
      _buildCustomTextFormField('State', Icons.location_city),
      SizedBox(height: 20),
      _buildCustomTextFormField('Pincode', Icons.location_city),
      SizedBox(height: 20),
      Text(
        "Concern Person1 Details",
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
      ),
      SizedBox(height: 20),
      _buildCustomTextFormField('Name', Icons.location_city),
      SizedBox(height: 20),
      _buildCustomTextFormField('Position', Icons.location_city),
      SizedBox(height: 20),
      _buildCustomTextFormField('Phone Number 1', Icons.location_city),
      SizedBox(height: 20),
      _buildCustomTextFormField('Phone Number 2', Icons.location_city),
      SizedBox(height: 20),
      Text(
        "Concern Person2 Details",
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
      ),
      SizedBox(height: 20),
      _buildCustomTextFormField('Name', Icons.location_city),
      SizedBox(height: 20),
      _buildCustomTextFormField('Position', Icons.location_city),
      SizedBox(height: 20),
      _buildCustomTextFormField('Phone Number 1', Icons.location_city),
      SizedBox(height: 20),
      _buildCustomTextFormField('Phone Number 2', Icons.location_city),
      SizedBox(height: 20),
      Text(
        "Event Planning",
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
      ),
      SizedBox(height: 20),
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
      SizedBox(height: 20),
      _buildRadioOption('Road Access Site:', _options, _selectedValue, (value) {
        setState(() {
          _selectedValue = value;
        });
      }),
      SizedBox(height: 20),
      _buildCustomTextFormField('Total Square Feet', Icons.area_chart_outlined),
      SizedBox(height: 20),
      _buildRadioOption('Water Availability:', _options, _selectedValue2, (value) {
        setState(() {
          _selectedValue2 = value;
        });
      }),
      SizedBox(height: 20),
      _buildCustomTextFormField('No Of Patient Expected', Icons.person),
      SizedBox(height: 20),
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

      SizedBox(height: 30),

      // Login Button
      Center(
        child: CustomButton(text: "Submit", onPressed: () {

        }).animate().move(
            delay: const Duration(milliseconds: 400),
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut),
      ),

      // Forgot Password Link
      SizedBox(height: 20),
    ];
    return fields;
  }

  Widget _buildCustomTextFormField(String label, IconData icon) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      child: CustomTextFormField(
        labelText: label,
        icon: icon,
      ),
    );
  }

  Widget _buildRadioOption(String label, List<String> options, String? selectedValue, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
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
