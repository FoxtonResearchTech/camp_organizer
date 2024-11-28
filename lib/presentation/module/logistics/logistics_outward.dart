import 'package:flutter/material.dart';
import 'package:camp_organizer/widgets/Text%20Form%20Field/custom_text_form_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/AddEvent/add_logistics_bloc.dart';
import '../../../bloc/AddEvent/add_logistics_event.dart';
import '../../notification/notification.dart';

class LogisticsOutward extends StatefulWidget {
  final String documentId;
  final Map<String, dynamic> campData;

  const LogisticsOutward(
      {Key? key, required this.documentId, required this.campData})
      : super(key: key);

  @override
  State<LogisticsOutward> createState() => _LogisticsOutwardState();
}

class _LogisticsOutwardState extends State<LogisticsOutward> {
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
      'Outward_cameraIn': cameraInController.text.trim(),
      'Outward_cameraOut': cameraOutController.text.trim(),
      'Outward_inChargeName': inChargeNameController.text.trim(),
      'Outward_dutyInCharge1': dutyInCharge1Controller.text.trim(),
      'Outward_dutyInCharge2': dutyInCharge2Controller.text.trim(),
      'Outward_remarks': remarksController.text.trim(),
      'Outward_doctorRoomThings': doctorRoomThings,
      'Outward_visionRoomThings': visionRoomThings,
      'Outward_crRoomThings': crRoomThings,
      'Outward_tnDuctThings': tnDuctThings,
      'Outward_opticalThings': opticalThings,
      'Outward_fittingThings': fittingThings,
      'Outward_others': others,
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
          'Outward Requirement',
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
              SizedBox(height: 20),
              CustomTextFormField(
                controller: campPlaceController,
                labelText: "Camp Place",
              ),
              SizedBox(height: 20),
              CustomTextFormField(
                controller: dateController,
                labelText: "Date",
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

              CustomTextFormField(
                controller: cameraInController,
                labelText: 'Camera In',
              ),
              SizedBox(height: 20),
              CustomTextFormField(
                controller: cameraOutController,
                labelText: 'Camera Out',
              ),
              SizedBox(height: 20),

              CustomTextFormField(
                controller: inChargeNameController,
                labelText: 'In-Charge Name',
              ),
              SizedBox(height: 20),
              CustomTextFormField(
                controller: dutyInCharge1Controller,
                labelText: 'Duty In-Charge 1',
              ),
              SizedBox(height: 20),
              CustomTextFormField(
                controller: dutyInCharge2Controller,
                labelText: 'Duty In-Charge 2',
              ),
              SizedBox(height: 20),
              CustomTextFormField(
                controller: remarksController,
                labelText: 'Remarks',
              ),

              SizedBox(height: 20),

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
