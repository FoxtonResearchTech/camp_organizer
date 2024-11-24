import 'package:camp_organizer/widgets/button/custom_button.dart';
import 'package:flutter/material.dart';

import '../../notification/notification.dart';

class LogisticsOutwardPage extends StatelessWidget {
  final Map<String, dynamic> campData;

  const LogisticsOutwardPage({Key? key, required this.campData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Logistics Outward Details',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGradientCard(
              context,
              title: 'Outward Doctor Room Things',
              content: _buildCheckList(campData['Outward_doctorRoomThings'] ?? {}),
            ),
            _buildGradientCard(
              context,
              title: 'Outward CR Room Things',
              content: _buildCheckList(campData['Outward_crRoomThings'] ?? {}),
            ),
            _buildGradientCard(
              context,
              title: 'Outward Optical Things',
              content: _buildCheckList(campData['Outward_opticalThings'] ?? {}),
            ),
            _buildGradientCard(
              context,
              title: 'Outward Fitting Things',
              content: _buildCheckList(campData['Outward_fittingThings'] ?? {}),
            ),
            _buildGradientCard(
              context,
              title: 'Outward Vision Room Things',
              content: _buildCheckList(campData['Outward_visionRoomThings'] ?? {}),
            ),
            _buildGradientCard(
              context,
              title: 'Outward T&Duct Things',
              content: _buildCheckList(campData['Outward_tnDuctThings'] ?? {}),
            ),

            _buildGradientCard(
              context,
              title: 'Other Items',
              content: _buildCheckList(campData['Outward_others'] ?? {}),
            ),
            SizedBox(height: 30,),
            Center(child: CustomButton(text: 'Submit', onPressed: () {}),
            ),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }

  // Helper method to create a gradient card for each section
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
