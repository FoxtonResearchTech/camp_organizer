import 'package:camp_organizer/bloc/AddEvent/event_bloc.dart';
import 'package:camp_organizer/bloc/AddEvent/event_event.dart';
import 'package:camp_organizer/bloc/AddEvent/event_state.dart';
import 'package:camp_organizer/presentation/notification/notification.dart';
import 'package:camp_organizer/utils/app_colors.dart';
import 'package:camp_organizer/widgets/Dropdown/custom_dropdown.dart';
import 'package:camp_organizer/widgets/Text%20Form%20Field/custom_text_form_field.dart';
import 'package:camp_organizer/widgets/button/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({super.key});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent>
    with SingleTickerProviderStateMixin {
  late TextEditingController _dateController;
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

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
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.0, 0.1), end: Offset.zero)
            .animate(CurvedAnimation(
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
    _controller.dispose();
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
  final TextEditingController positionController =
  TextEditingController();
  final TextEditingController position2Controller =
  TextEditingController();
  final TextEditingController phoneNumber2_2Controller =
      TextEditingController();
  final TextEditingController totalSquareFeetController =
      TextEditingController();
  final TextEditingController noOfPatientExpectedController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Camp',
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NotificationPage()));
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
                                timeController.text =
                                    pickedTime.format(context);
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
                  SizedBox(height: 20),
                  ..._buildFormFields(),
                  // Method to build the rest of the form fields
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormFields() {
    final bloc = BlocProvider.of<EventFormBloc>(context);
    List<Widget> fields = [
      _buildCustomTextFormField(
          'Camp Name', Icons.location_city, campNameController),
      SizedBox(height: 20),
      _buildCustomTextFormField(
          'Organization', Icons.location_city, organizationController),
      SizedBox(height: 20),
      _buildCustomTextFormField('Address', Icons.home, addressController),
      SizedBox(height: 20),
      _buildCustomTextFormField('City', Icons.location_city, cityController),
      SizedBox(height: 20),
      _buildCustomTextFormField('State', Icons.location_city, stateController),
      SizedBox(height: 20),
      _buildCustomTextFormField(
          'Pincode', Icons.location_city, pincodeController),
      SizedBox(height: 20),
      Text(
        "Concern Person1 Details",
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
      ),
      SizedBox(height: 20),
      _buildCustomTextFormField('Name', Icons.location_city, nameController),
      SizedBox(height: 20),
      _buildCustomTextFormField(
          'Position', Icons.location_city, positionController),
      // Assuming Position field is here
      SizedBox(height: 20),
      _buildCustomTextFormField(
          'Phone Number 1', Icons.location_city, phoneNumber1Controller),
      SizedBox(height: 20),
      _buildCustomTextFormField(
          'Phone Number 2', Icons.location_city, phoneNumber2Controller),
      SizedBox(height: 20),
      Text(
        "Concern Person2 Details",
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
      ),
      SizedBox(height: 20),
      _buildCustomTextFormField('Name', Icons.location_city, name2Controller),
      SizedBox(height: 20),
      _buildCustomTextFormField(
          'Position', Icons.location_city, position2Controller),
      SizedBox(height: 20),
      _buildCustomTextFormField(
          'Phone Number 1', Icons.location_city, phoneNumber1_2Controller),
      SizedBox(height: 20),
      _buildCustomTextFormField(
          'Phone Number 2', Icons.location_city, phoneNumber2_2Controller),
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
      _buildCustomTextFormField('Total Square Feet', Icons.area_chart_outlined,
          totalSquareFeetController),
      SizedBox(height: 20),
      _buildRadioOption('Water Availability:', _options, _selectedValue2,
          (value) {
        setState(() {
          _selectedValue2 = value;
        });
      }),
      SizedBox(height: 20),
      _buildCustomTextFormField('No Of Patient Expected', Icons.person,
          noOfPatientExpectedController),
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
        child: BlocConsumer<EventFormBloc, EventFormState>(
          listener: (context, state) {
            if (state is FormSubmitFailure) {
              // Show failure SnackBar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error), // Display the error message
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is FormSubmitDuplicate) {
              // Show duplicate entry SnackBar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Something went wrong please try again!'),
                  backgroundColor: Colors.orange,
                ),
              );
            } else if (state is FormSubmitSuccess) {
              // Show success SnackBar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Camp created successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
          builder: (context, currentState) {
            return currentState is FormSubmitting
                ? Center(
                    child: SpinKitPumpingHeart(
                      color: Colors.blue,
                      size: 50.0,
                    ),
                  )
                : CustomButton(
                    text: "Submit",
                    onPressed: () {
                      bloc.add(SubmitForm(
                        campName: campNameController.text,
                        organization: organizationController.text,
                        address: addressController.text,
                        city: cityController.text,
                        state: stateController.text,
                        pincode: pincodeController.text,
                        name: nameController.text,
                        phoneNumber1: phoneNumber1Controller.text,
                        phoneNumber2: phoneNumber2Controller.text,
                        name2: name2Controller.text,
                        phoneNumber1_2: phoneNumber1_2Controller.text,
                        phoneNumber2_2: phoneNumber2_2Controller.text,
                        totalSquareFeet: totalSquareFeetController.text,
                        noOfPatientExpected: noOfPatientExpectedController.text,
                        position2: position2Controller.text,
                        campPlanType: campPlanselectedValue.toString(),
                        roadAccess: _selectedValue.toString(),
                        waterAvailability: _selectedValue2.toString(),
                        lastCampDone: lastselectedValue.toString(),
                        campDate: _dateController.text,
                        campTime: timeController.text,
                        position: positionController.text,
                      ));
                    },
                  );
          },
        ),
      ),
      // Forgot Password Link
      SizedBox(height: 20),
    ];
    return fields;
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
