import 'package:camp_organizer/widgets/button/custom_button.dart';
import 'package:flutter/material.dart';

import '../../notification/notification.dart';

class LogisticsOutwardPage extends StatelessWidget {
  final Map<String, dynamic> campData;

  const LogisticsOutwardPage({Key? key, required this.campData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios,color: Colors.white,)),
        title: const Text(
          'Logistics Outward Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'LeagueSpartan',
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [ Color(0xFF0097b2),  Color(0xFF0097b2).withOpacity(1), Color(0xFF0097b2).withOpacity(0.8)],
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
              title: 'Outward Doctor Room Things',
              content:
              _buildCheckList(campData['Outward_doctorRoomThings'] ?? {}),
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
              content:
              _buildCheckList(campData['Outward_visionRoomThings'] ?? {}),
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
            SizedBox(
              height: 30,
            ),
            _buildAnimatedSection(
              context,
              sectionTitle: 'More Outward Details',
              children: [
                _buildInfoCard('Camera Out', campData['Outward_cameraOut']),
                _buildInfoCard('In-Charge Name', campData['Outward_inChargeName']),
                _buildInfoCard('Duty Incharge 1', campData['Outward_dutyInCharge1']),
                _buildInfoCard('Duty Incharge 2', campData['Outward_dutyInCharge2']),
                _buildInfoCard('Remarks', campData['Outward_remarks']),
              ],
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

  // Helper method to create a gradient card for each section
  Widget _buildGradientCard(BuildContext context,
      {required String title, required List<Widget> content}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff0097b2),
            Color(0xff0097b2).withOpacity(0.5)!,],
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
                fontFamily: 'LeagueSpartan',
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
            fontFamily: 'LeagueSpartan',color: Colors.white,fontWeight: FontWeight.bold
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
            Color(0xff0097b2),
            Color(0xff0097b2).withOpacity(0.5)!,
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
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          value?.toString() ?? 'N/A',
          style: const TextStyle(
            color: Colors.white,fontWeight: FontWeight.bold,
            fontFamily: 'LeagueSpartan',
          ),
        ),
      ),
    );
  }
}
