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
            color: Colors.white,
            fontFamily: 'LeagueSpartan',
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
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
            _buildAnimatedSection(
              context,
              sectionTitle: 'More Outward Details',
              children: [
                _buildInfoCard('Camera Out', widget.campData['Inward_cameraIn']),
                _buildInfoCard('In-Charge Name', widget.campData['Inward_inChargeName']),
                _buildInfoCard('Duty Incharge 1', widget.campData['Inward_dutyInCharge1']),
                _buildInfoCard('Duty Incharge 2', widget.campData['Inward_dutyInCharge2']),
                _buildInfoCard('Remarks', widget.campData['Inward_remarks']),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: CustomButton(text: 'Done', onPressed: () {
                Navigator.pop(context); // Go back to the previous page
              }),
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
      width: double.infinity,
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
                fontFamily: 'LeagueSpartan',
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
        title: Text(
          entry.key,
          style: TextStyle(
            fontFamily: 'LeagueSpartan',
          ),
        ),
        value: entry.value,
        onChanged: (bool? value) {
          // Logic for handling checkbox state change can be added here
        },
      );
    }).toList();
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
          fontFamily: 'LeagueSpartan',
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
            fontFamily: 'LeagueSpartan',
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          value?.toString() ?? 'N/A',
          style: const TextStyle(
            color: Colors.black54,
            fontFamily: 'LeagueSpartan',
          ),
        ),
      ),
    );
  }
}
