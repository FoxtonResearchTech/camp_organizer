import 'package:camp_organizer/widgets/button/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../../bloc/AddEvent/add_finance_bloc.dart';
import '../../../bloc/AddEvent/add_finance_event.dart';
import '../../../bloc/AddEvent/add_finance_state.dart';
import '../../../bloc/AddEvent/patient_follow_ups_bloc.dart';
import '../../../bloc/AddEvent/patient_follow_ups_event.dart';
import '../../../bloc/AddEvent/patient_follow_ups_state.dart';
import '../../../widgets/Text Form Field/custom_text_form_field.dart';
import '../../notification/notification.dart';

class PostCampFollow extends StatefulWidget {
  final String documentId;
  final Map<String, dynamic> campData;

  const PostCampFollow(
      {Key? key, required this.documentId, required this.campData})
      : super(key: key);

  @override
  State<PostCampFollow> createState() => _PostCampFollowState();
}

class _PostCampFollowState extends State<PostCampFollow> {
  final TextEditingController additionalInfo = TextEditingController();
  final TextEditingController remarks = TextEditingController();

  void saveData(BuildContext context, documentId) {
    final Map<String, dynamic> data = {
      'followInfo': additionalInfo.text.trim(),
      'followRemark': remarks.text.trim()
    };
    context.read<PatientFollowUpsBloc>().add(AddPatientFollowUpsWithDocumentId(
        documentId: widget.documentId, data: data));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 10),
            Expanded(child: Text('Follow up data submitted successfully')),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: Duration(seconds: 3),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (_) =>
          PatientFollowUpsBloc(firestore: FirebaseFirestore.instance),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios,color: Colors.white,)),
          title: const Text(
            'Post Camp Follow UP',
            style: TextStyle(
                fontFamily: 'LeagueSpartan',
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold),
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
        body:  BlocListener<PatientFollowUpsBloc, PatientFollowUpsState>(
                listener: (context, state) {
                  if (state is PatientFollowUpsSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Center(child: Text('Data saved successfully!')),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else if (state is PatientFollowUpsError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Center(child: Text('Error: ${state.message}')),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child:  widget.campData['patientFollowUps'] != null ? SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        _buildAnimatedSection(
                          context,
                          sectionTitle: 'Camp Info',
                          children: [
                            _buildInfoCard(
                                'Camp Name', widget.campData['campName']),
                            _buildInfoCard('Camp Date', widget.campData['campDate']),
                            _buildInfoCard('Camp Place', widget.campData['place']),
                          ],
                        ),
                        // Section for Patient Follow-Ups
                        _buildAnimatedSection(
                          context,
                          sectionTitle: 'Patient Follow-Ups',
                          children: _buildPatientFollowUpCards(
                              widget.campData['patientFollowUps']),
                        ),
                        _buildAnimatedSection(
                          context,
                          sectionTitle: 'Add Follow Ups Info',
                          children: [],
                        ),
                        SizedBox(height: 20),
                        CustomTextFormField(
                          labelText: 'Additional Info',
                          controller: additionalInfo,
                        ),
                        SizedBox(height: 20),
                        CustomTextFormField(
                          labelText: 'Remarks',
                          controller: remarks,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CustomButton(
                            text: 'Submit',
                            onPressed: () {
                              saveData(context, widget.documentId);
                            }),
                      ],
                    ),
                  ),
                ):SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.only(top: screenHeight / 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            'assets/no_data.json',
                            width: screenWidth * 0.35,
                            height: screenHeight * 0.25,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Camp Incharge not submitted the data",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'LeagueSpartan',
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  List<Widget> _buildPatientFollowUpCards(List<dynamic> patientFollowUps) {
    if (patientFollowUps.isEmpty) {
      // Display a message if the list is empty
      return [
        Container(
          padding: const EdgeInsets.all(20.0),
          alignment: Alignment.center,
          child: Text(
            'No follow-up data available',
            style: TextStyle(
              fontFamily: 'LeagueSpartan',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ];
    }

    // If list is not empty, display patient follow-up cards
    return patientFollowUps.map((patient) {
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
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
          title: Text(
            patient['name'] ?? 'N/A',
            style: const TextStyle(
              fontFamily: 'LeagueSpartan',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Text(
                'Phone: ${patient['phone'] ?? 'N/A'}',
                style: const TextStyle(
                  color: Colors.white70,fontWeight: FontWeight.bold,
                  fontFamily: 'LeagueSpartan',
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Status: ${patient['status'] ?? 'N/A'}',
                style: const TextStyle(
                  color: Colors.white70,fontWeight: FontWeight.bold,
                  fontFamily: 'LeagueSpartan',
                ),
              ),
            ],
          ),
        ),
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
