import 'package:flutter/material.dart';

import '../../../widgets/Text Form Field/custom_text_form_field.dart';
import '../../notification/notification.dart';

class LogisticsInward extends StatefulWidget {
  const LogisticsInward({super.key});

  @override
  State<LogisticsInward> createState() => _LogisticsInwardState();
}

class _LogisticsInwardState extends State<LogisticsInward> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  String campPlace = '';
  String date = '';
  String cameraIn = '';
  String cameraOut = '';
  String inChargeName = '';
  String dutyInCharge1 = '';
  String dutyInCharge2 = '';
  String remarks = '';

  // Checkbox states for each category
  Map<String, bool> doctorRoomThings = {
    "Torch Light": false,
    "Ophthalmoscope": false,
    "Bastin": false,
    "Head Loupe": false,
    "Record Things": false,
    "Medicine Things": false,
    "Medicine": false,
    "Glass Pad": false,
  };

  Map<String, bool> visionRoomThings = {
    "Trial Set1": false,
    "Trial Set2": false,
    "Trial Frame1": false,
    "Trial Frame2": false,
    "Pinhole1": false,
    "Pinhole2": false,
    "Occluder1": false,
    "Occluder2": false,
    "Snellen Chart": false,
    "NV Chart": false,
  };

  Map<String, bool> crRoomThings = {
    "CR Machine No 1": false,
    "CR Machine No 2": false,
    "CR Machine No 3": false,
    "Stabilizer": false,
    "Junction Box Wire": false,
    "Rollin Chair": false,
  };

  Map<String, bool> tnDuctThings = {
    "Bed Sheet": false,
    "Urine Bottle": false,
    "TN Duct Box": false,
    "Schultz Ton Meter": false,
    "BP Apparatus": false,
    "Stethoscope": false,
  };

  Map<String, bool> opticalThings = {
    "Frame Bag": false,
    "Bill Machine": false,
  };

  Map<String, bool> fittingThings = {
    "Fitting Machine & Table": false,
    "Lens Bag": false,
    "Switch Board": false,
  };

  Map<String, bool> others = {
    "Register Note": false,
    "Banner": false,
    "Camera": false,
  };

  // Function to build a checklist
  Widget buildChecklistCategory(String title, Map<String, bool> items) {
    return ExpansionTile(
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      children: items.keys.map((item) {
        return CheckboxListTile(
          title: Text(item),
          value: items[item],
          onChanged: (bool? value) {
            setState(() {
              items[item] = value!;
            });
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Inward Checklist',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Input for camp place and date
              SizedBox(height: 20,),
              CustomTextFormField(labelText: "Camp Place",onSaved: (value) => campPlace = value ?? '',),
              SizedBox(height: 20,),
              CustomTextFormField(labelText: "Date",onSaved: (value) => date = value ?? '',),


              SizedBox(height: 20),

              // Checklists for each category
              buildChecklistCategory("Doctor Room Things", doctorRoomThings),
              buildChecklistCategory("Vision Room Things", visionRoomThings),
              buildChecklistCategory("CR Room Things", crRoomThings),
              buildChecklistCategory("TN Duct Things", tnDuctThings),
              buildChecklistCategory("Optical Things", opticalThings),
              buildChecklistCategory("Fitting Things", fittingThings),
              buildChecklistCategory("Others", others),

              SizedBox(height: 20),

              // Fields for camera in/out
              CustomTextFormField(labelText: 'Camera In',onSaved: (value) => cameraIn = value ?? '',),
              SizedBox(height: 20),
              CustomTextFormField(labelText: 'Camera Out',onSaved: (value) => cameraOut = value ?? '',),

              SizedBox(height: 20),

              // Input for in-charge names
              CustomTextFormField(labelText: 'In-Charge Name',onSaved: (value) => inChargeName = value ?? '',),
              SizedBox(height: 20,),
              CustomTextFormField(labelText: 'Duty In-Charge 1',onSaved: (value) => dutyInCharge1 = value ?? '',),
              SizedBox(height: 20,),
              CustomTextFormField(labelText: 'Duty In-Charge 2',onSaved: (value) => dutyInCharge2 = value ?? '',),
              SizedBox(height: 20),
              CustomTextFormField(labelText: 'Remarks',onSaved: (value) => remarks = value ?? '',),


              SizedBox(height: 20),

              // Submit button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // Print or process the form data
                    print("Camp Place: $campPlace");
                    print("Date: $date");
                    print("Doctor Room Things: $doctorRoomThings");
                    print("Vision Room Things: $visionRoomThings");
                    print("CR Room Things: $crRoomThings");
                    print("TN Duct Things: $tnDuctThings");
                    print("Optical Things: $opticalThings");
                    print("Fitting Things: $fittingThings");
                    print("Others: $others");
                    print("Camera In: $cameraIn");
                    print("Camera Out: $cameraOut");
                    print("In-Charge Name: $inChargeName");
                    print("Duty In-Charge 1: $dutyInCharge1");
                    print("Duty In-Charge 2: $dutyInCharge2");
                  }
                },
                child: Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
