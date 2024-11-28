import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/AddEvent/add_logistics_bloc.dart';
import '../../../bloc/AddEvent/add_logistics_event.dart';
import '../../../widgets/Text Form Field/custom_text_form_field.dart';
import '../../notification/notification.dart';

class LogisticsInward extends StatefulWidget {
  final String documentId;
  final Map<String, dynamic> campData;

  const LogisticsInward(
      {Key? key, required this.documentId, required this.campData})
      : super(key: key);

  @override
  State<LogisticsInward> createState() => _LogisticsInwardState();
}

class _LogisticsInwardState extends State<LogisticsInward> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController campPlaceController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController cameraInController = TextEditingController();
  final TextEditingController cameraOutController = TextEditingController();
  final TextEditingController inChargeNameController = TextEditingController();
  final TextEditingController dutyInCharge1Controller = TextEditingController();
  final TextEditingController dutyInCharge2Controller = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

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

  void saveData(BuildContext context, String documentId) {
    final Map<String, dynamic> data = {
      'campPlace': campPlaceController.text.trim(),
      'date': dateController.text.trim(),
      'Inward_cameraIn': cameraInController.text.trim(),
      'Inward_cameraOut': cameraOutController.text.trim(),
      'Inward_inChargeName': inChargeNameController.text.trim(),
      'Inward_dutyInCharge1': dutyInCharge1Controller.text.trim(),
      'Inward_dutyInCharge2': dutyInCharge2Controller.text.trim(),
      'Inward_remarks': remarksController.text.trim(),
      'Inward_doctorRoomThings': doctorRoomThings,
      'Inward_visionRoomThings': visionRoomThings,
      'Inward_crRoomThings': crRoomThings,
      'Inward_tnDuctThings': tnDuctThings,
      'Inward_opticalThings': opticalThings,
      'Inward_fittingThings': fittingThings,
      'Inward_others': others,
    };
    // Dispatch the data to the BLoC
    context.read<AddLogisticsBloc>().add(
        AddLogisticsWithDocumentId(documentId: widget.documentId, data: data));
  }

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
  void dispose() {
    // Dispose controllers to release resources
    campPlaceController.dispose();
    dateController.dispose();
    cameraInController.dispose();
    cameraOutController.dispose();
    inChargeNameController.dispose();
    dutyInCharge1Controller.dispose();
    dutyInCharge2Controller.dispose();
    remarksController.dispose();
    super.dispose();
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Input for camp place and date
              SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                labelText: "Camp Place",
                controller: campPlaceController,
              ),
              SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                labelText: "Date",
                controller: dateController,
              ),

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
              CustomTextFormField(
                labelText: 'Camera In',
                controller: cameraInController,
              ),
              SizedBox(height: 20),
              CustomTextFormField(
                labelText: 'Camera Out',
                controller: cameraOutController,
              ),

              SizedBox(height: 20),

              // Input for in-charge names
              CustomTextFormField(
                labelText: 'In-Charge Name',
                controller: inChargeNameController,
              ),
              SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                labelText: 'Duty In-Charge 1',
                controller: dutyInCharge1Controller,
              ),
              SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                labelText: 'Duty In-Charge 2',
                controller: dutyInCharge2Controller,
              ),
              SizedBox(height: 20),
              CustomTextFormField(
                labelText: 'Remarks',
                controller: remarksController,
              ),

              SizedBox(height: 20),

              // Submit button
              ElevatedButton(
                onPressed: () {
                  saveData(context, widget.documentId);
                  print(widget.documentId);
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
