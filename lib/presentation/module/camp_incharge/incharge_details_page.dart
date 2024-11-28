import 'package:flutter/material.dart';
import 'package:camp_organizer/widgets/button/custom_button.dart';

class InchargeDetailsPage extends StatelessWidget {
  final Map<String, dynamic> inchargeData;

  const InchargeDetailsPage({Key? key, required this.inchargeData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios,color: Colors.white,)),
        title: const Text(
          'Incharge Details',
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
            _buildAnimatedSection(
              context,
              sectionTitle: 'Incharge Info',
              children: [
                _buildInfoCard('Name', inchargeData['name']),
                _buildInfoCard('Employee ID', inchargeData['EmployeeId']),
                _buildInfoCard('Position', inchargeData['position']),
                _buildInfoCard('In-Charge', inchargeData['incharge']),
                _buildInfoCard('Camp Name', inchargeData['campName'] ?? 'N/A'),
                _buildInfoCard('Camp Status', inchargeData['campStatus']),
                _buildInfoCard('Camp Date', inchargeData['campDate']),
                _buildInfoCard('Camp Time', inchargeData['campTime']),

                _buildInfoCard('Camp Plan Type', inchargeData['campPlanType']),

                _buildInfoCard('Doctor', inchargeData['doctor']),
                _buildInfoCard('Last Camp Done', inchargeData['lastCampDone']),
              ],
            ),
            _buildAnimatedSection(
              context,
              sectionTitle: 'Location Info',
              children: [
                _buildInfoCard('City', inchargeData['city']),
                _buildInfoCard('State', inchargeData['state']),
                _buildInfoCard('Address', inchargeData['address']),
                _buildInfoCard('Pincode', inchargeData['pincode']),
                _buildInfoCard('Road Access', inchargeData['roadAccess']),
                _buildInfoCard('Water Availability', inchargeData['waterAvailability']),
                _buildInfoCard('Total Square Feet', inchargeData['totalSquareFeet']),
                _buildInfoCard('Place', inchargeData['place']),
                _buildInfoCard('Vehicle Number', inchargeData['vehicleNumber']),
              ],
            ),
            _buildAnimatedSection(
              context,
              sectionTitle: 'Team & Organization',
              children: [
                _buildInfoCard('Driver', inchargeData['driver']),
                _buildInfoCard('Teams', inchargeData['teams']?.join(', ') ?? 'N/A'),
                _buildInfoCard('Organization', inchargeData['organization']),
                _buildInfoCard('Position 2', inchargeData['position2']),
                _buildInfoCard('Regnter', inchargeData['regnter']),
                _buildInfoCard('Counselling', inchargeData['counselling']),
                _buildInfoCard('Doctor Room', inchargeData['drRoom']),
                _buildInfoCard('Optical', inchargeData['optical']),
              ],
            ),
            _buildAnimatedSection(
              context,
              sectionTitle: 'Contact Details',
              children: [
                _buildInfoCard('Primary Phone', inchargeData['phoneNumber1']),
                _buildInfoCard('Secondary Phone 1', inchargeData['phoneNumber2']),
                _buildInfoCard('Secondary Phone 2', inchargeData['phoneNumber2_2']),
                _buildInfoCard('Alternate Phone', inchargeData['phoneNumber1_2']),
                _buildInfoCard('Employee Email', inchargeData['EmployeeId']),

              ],
            ),
            _buildAnimatedSection(
              context,
              sectionTitle: 'Additional Info',
              children: [
                _buildInfoCard('Number of Patients Expected', inchargeData['noOfPatientExpected']),
                _buildInfoCard('Cataract Patients', inchargeData['cataractPatients']),
                _buildInfoCard('Diabetic Patients', inchargeData['diabeticPatients']),
                _buildInfoCard('Patients Attended', inchargeData['patientsAttended']),
                _buildInfoCard('Patients Selected for Surgery', inchargeData['patientsSelectedForSurgery']),
                _buildInfoCard('Number of Glasses Supplied', inchargeData['glassesSupplied']),
                _buildInfoCard('Km Run', inchargeData['kmRun']),
                _buildInfoCard('Date', inchargeData['date']),
                _buildInfoCard('Time', inchargeData['time']),
                _buildInfoCard('Patient Follow-ups', inchargeData['patientFollowUps']?.join(', ') ?? 'N/A'),

                _buildInfoCard('AR', inchargeData['ar'] ?? 'N/A'),
                _buildInfoCard('VN Reg', inchargeData['vnReg'] ?? 'N/A'),
                _buildInfoCard('Name 2', inchargeData['name2']),
              ],
            ),
            Center(child: CustomButton(text: 'Approve', onPressed: () {})),
          ],
        ),
      ),
    );
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
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          value?.toString() ?? 'N/A',
          style: const TextStyle(color: Colors.black54),
        ),
      ),
    );
  }
}
