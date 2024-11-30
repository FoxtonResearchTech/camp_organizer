import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../bloc/approval/adminapproval_bloc.dart';
import '../../../bloc/approval/adminapproval_event.dart';
import '../../../widgets/button/custom_button.dart';
import '../../notification/notification.dart';

class FinanceDetails extends StatefulWidget {
  final Map<String, dynamic> campData;

  const FinanceDetails({Key? key, required this.campData}) : super(key: key);

  @override
  State<FinanceDetails> createState() => _FinanceDetailsState();
}

class _FinanceDetailsState extends State<FinanceDetails> {
  @override
  Widget build(BuildContext context) {
    String formattedCreatedOn = _formatCreatedOn(widget.campData['CreatedOn']);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Camp Expenses',
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
              colors: [ Color(0xFF0097b2),  Color(0xFF0097b2).withOpacity(1), Color(0xFF0097b2).withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
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
                _buildInfoCard('Camp Name', widget.campData['campName']),
                _buildInfoCard('Status', widget.campData['campStatus']),
                _buildInfoCard('Date', widget.campData['campDate']),
                _buildInfoCard('Time', widget.campData['campTime']),
                _buildInfoCard(
                    'Camp Plan Type', widget.campData['campPlanType']),
                _buildInfoCard(
                    'Last Camp Done', widget.campData['lastCampDone']),
              ],
            ),
            _buildAnimatedSection(
              context,
              sectionTitle: 'Location Info',
              children: [
                _buildInfoCard('City', widget.campData['city']),
                _buildInfoCard('State', widget.campData['state']),
                _buildInfoCard('Road Access', widget.campData['roadAccess']),
                _buildInfoCard(
                    'Water Availability', widget.campData['waterAvailability']),
                _buildInfoCard(
                    'Total Square Feet', widget.campData['totalSquareFeet']),
                _buildInfoCard('Pincode', widget.campData['pincode']),
                _buildInfoCard('Address', widget.campData['address']),
              ],
            ),
            _buildAnimatedSection(
              context,
              sectionTitle: 'Team & Organization',
              children: [
                _buildInfoCard('In-Charge', widget.campData['incharge']),
                _buildInfoCard('Doctor', widget.campData['doctor']),
                _buildInfoCard('Driver', widget.campData['driver']),
                _buildInfoCard(
                    'Teams', widget.campData['teams']?.join(', ') ?? 'N/A'),
                _buildInfoCard('Organization', widget.campData['organization']),
              ],
            ),
            _buildAnimatedSection(
              context,
              sectionTitle: 'Contact Details',
              children: [
                _buildInfoCard(
                    'Primary Phone', widget.campData['phoneNumber1']),
                _buildInfoCard(
                    'Alternate Phone', widget.campData['phoneNumber1_2']),
                _buildInfoCard(
                    'Secondary Phone 1', widget.campData['phoneNumber2']),
                _buildInfoCard(
                    'Secondary Phone 2', widget.campData['phoneNumber2_2']),
                _buildInfoCard('Employee Email', widget.campData['EmployeeId']),
              ],
            ),
            _buildAnimatedSection(
              context,
              sectionTitle: 'Additional Info',
              children: [
                _buildInfoCard('Number of Patients Expected',
                    widget.campData['noOfPatientExpected']),
                _buildInfoCard('Position', widget.campData['position']),
                _buildInfoCard('Created On', formattedCreatedOn),
                _buildInfoCard('AR', widget.campData['ar'] ?? 'N?A'),
              ],
            ),
            _buildAnimatedSection(
              context,
              sectionTitle: 'Finance Information',
              children: [
                _buildInfoCard(
                    'Other Expenses', widget.campData['otherExpenses']),
                _buildInfoCard(
                    'Vehicle Expenses', widget.campData['vehicleExpenses']),
                _buildInfoCard('Staff Salary', widget.campData['staffSalary']),
                _buildInfoCard('OT X 750', widget.campData['ot'] ?? 'N?A'),
                _buildInfoCard('CAT X 2000', widget.campData['cat'] ?? 'N?A'),
                _buildInfoCard(
                    'GP Paying Case', widget.campData['gpPayingCase'] ?? 'N?A'),
                _buildInfoCard('Remarks', widget.campData['remarks'] ?? 'N?A'),
              ],
            ),
            Center(
              child: CustomButton(
                text: 'Approve',
                onPressed: () {
                  try {
                    BlocProvider.of<AdminApprovalBloc>(context).add(
                      UpdateStatusEvent(
                        employeeId: widget.campData['employeeDocId'],
                        campDocId: widget.campData['documentId'],
                        newStatus: 'Completed',
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Center(
                          child: Text('Status changed to Completed',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Center(
                          child: Text('Failed to update status ',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to format the 'Created On' timestamp to a readable date format
  String _formatCreatedOn(dynamic createdOn) {
    if (createdOn == null) return 'N/A';
    try {
      int timestampSeconds = createdOn.seconds; // Assuming 'seconds' is the field name for timestamp
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestampSeconds * 1000);
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime); // Format as desired
    } catch (e) {
      return 'Invalid Date'; // Handle any parsing issues
    }
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
          fontFamily: 'LeagueSpartan',
          color: Colors.lightBlue[800],
        ),
      ),
    );
  }

  // Helper method to build information cards
  Widget _buildInfoCard(String label, dynamic value) {
    return Material(
      color: Colors.transparent, // Keep the background transparent
      child: Container(
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
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
          title: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'LeagueSpartan',
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            value?.toString() ?? 'N/A',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'LeagueSpartan',
            ),
          ),
        ),
      ),
    );
  }
}
