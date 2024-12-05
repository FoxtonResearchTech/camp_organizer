import 'package:camp_organizer/connectivity_checker.dart';
import 'package:camp_organizer/widgets/button/custom_button.dart';
import 'package:flutter/material.dart';

class OnsiteCampDetailsPage extends StatelessWidget {
  final Map<String, dynamic> campData;

  const OnsiteCampDetailsPage({Key? key, required this.campData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConnectivityChecker(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        title: const Text(
          'Camp Details',
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
              colors: [
                Color(0xFF0097b2),
                Color(0xFF0097b2).withOpacity(1),
                Color(0xFF0097b2).withOpacity(0.8)
              ],
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
              sectionTitle: 'Camp Info',
              children: [
                _buildInfoCard('Camp Name', campData['campName']),
                _buildInfoCard('Status', campData['campStatus']),
                _buildInfoCard('Date', campData['campDate']),
                _buildInfoCard('Time', campData['campTime']),
                _buildInfoCard('Camp Plan Type', campData['campPlanType']),
                _buildInfoCard('Last Camp Done', campData['lastCampDone']),
              ],
            ),
            _buildAnimatedSection(
              context,
              sectionTitle: 'Location Info',
              children: [
                _buildInfoCard('City', campData['city']),
                _buildInfoCard('State', campData['state']),
                _buildInfoCard('Road Access', campData['roadAccess']),
                _buildInfoCard(
                    'Water Availability', campData['waterAvailability']),
                _buildInfoCard(
                    'Total Square Feet', campData['totalSquareFeet']),
                _buildInfoCard('Pincode', campData['pincode']),
                _buildInfoCard('Address', campData['address']),
              ],
            ),
            _buildAnimatedSection(
              context,
              sectionTitle: 'Team & Organization',
              children: [
                _buildInfoCard('In-Charge', campData['incharge']),
                _buildInfoCard('Doctor', campData['doctor']),
                _buildInfoCard('Driver', campData['driver']),
                _buildInfoCard('Organization', campData['organization']),
              ],
            ),
            _buildAnimatedSection(
              context,
              sectionTitle: 'Contact Details',
              children: [
                _buildInfoCard('Primary Phone', campData['phoneNumber1']),
                _buildInfoCard('Alternate Phone', campData['phoneNumber1_2']),
                _buildInfoCard('Secondary Phone 1', campData['phoneNumber2']),
                _buildInfoCard('Secondary Phone 2', campData['phoneNumber2_2']),
                _buildInfoCard('Employee Email', campData['EmployeeId']),
              ],
            ),
            _buildAnimatedSection(
              context,
              sectionTitle: 'Additional Info',
              children: [
                _buildInfoCard('Number of Patients Expected',
                    campData['noOfPatientExpected']),
                _buildInfoCard('Position', campData['position']),
                //   _buildInfoCard('Created On', campData['CreatedOn']?.toString() ?? 'N/A'),
                //    _buildInfoCard('Document ID', campData['documentId']),
                _buildInfoCard('AR', campData['ar'] ?? 'N?A'),
                _buildInfoCard('Vn Reg', campData['vnReg'] ?? 'N?A'),
                _buildInfoCard('Registration', campData['regnter'] ?? 'N?A'),
                _buildInfoCard('Dr. Room', campData['drRoom'] ?? 'N?A'),
                _buildInfoCard('Counselling', campData['counselling'] ?? 'N?A'),
                _buildInfoCard('Opticals', campData['optical'] ?? 'N?A'),
              ],
            ),
            Center(child: SizedBox()

                //     CustomButton(text: 'Approve', onPressed: () {})
                ),
          ],
        ),
      ),
    ));
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
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontFamily: 'LeagueSpartan',
          ),
        ),
      ),
    );
  }
}
