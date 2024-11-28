import 'package:flutter/material.dart';

import '../../../widgets/button/custom_button.dart';
import '../../notification/notification.dart';

class InwardDetails extends StatefulWidget {
  final Map<String, dynamic> campData;

  const InwardDetails({Key? key, required this.campData}) : super(key: key);

  @override
  State<InwardDetails> createState() => _InwardDetailsState();
}

class _InwardDetailsState extends State<InwardDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Logistics Inward Details',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGradientCard(
              context,
              title: 'Inward Doctor Room Things',
              content: _buildCheckList(
                  widget.campData['Inward_doctorRoomThings'] ?? {}),
            ),
            _buildGradientCard(
              context,
              title: 'Inward CR Room Things',
              content:
                  _buildCheckList(widget.campData['Inward_crRoomThings'] ?? {}),
            ),
            _buildGradientCard(
              context,
              title: 'Inward Optical Things',
              content: _buildCheckList(
                  widget.campData['Inward_opticalThings'] ?? {}),
            ),
            _buildGradientCard(
              context,
              title: 'Inward Fitting Things',
              content: _buildCheckList(
                  widget.campData['Inward_fittingThings'] ?? {}),
            ),
            _buildGradientCard(
              context,
              title: 'Inward Vision Room Things',
              content: _buildCheckList(
                  widget.campData['Inward_visionRoomThings'] ?? {}),
            ),
            _buildGradientCard(
              context,
              title: 'Inward T&Duct Things',
              content:
                  _buildCheckList(widget.campData['Inward_tnDuctThings'] ?? {}),
            ),
            _buildGradientCard(
              context,
              title: 'Other Inward Items',
              content: _buildCheckList(widget.campData['Inward_others'] ?? {}),
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: CustomButton(text: 'Submit', onPressed: () {}),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientCard(BuildContext context,
      {required String title, required List<Widget> content}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.cyan[100]!, Colors.cyan[50]!],
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
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.lightBlue[800],
              ),
            ),
            const SizedBox(height: 10),
            ...content,
          ],
        ),
      ),
    );
  }

  // Helper method to build a checklist for sublist items
  List<Widget> _buildCheckList(Map<String, dynamic> items) {
    return items.entries.map((entry) {
      return CheckboxListTile(
        title: Text(entry.key),
        value: entry.value,
        onChanged: (bool? value) {
          // Logic for handling checkbox state change can be added here
        },
      );
    }).toList();
  }
}
