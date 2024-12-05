import 'package:camp_organizer/connectivity_checker.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../widgets/Text Form Field/custom_text_form_field.dart';
import '../../../widgets/button/custom_button.dart';
import '../../notification/notification.dart';

class PostCampFollowCompleted extends StatefulWidget {
  final String documentId;
  final Map<String, dynamic> campData;

  const PostCampFollowCompleted(
      {Key? key, required this.documentId, required this.campData})
      : super(key: key);

  @override
  State<PostCampFollowCompleted> createState() =>
      _PostCampFollowCompletedState();
}

class _PostCampFollowCompletedState extends State<PostCampFollowCompleted> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return ConnectivityChecker(
        child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        title: const Text(
          'Completed Followup',
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
      body: widget.campData['followInfo'] == null
          ? Container(
              padding: EdgeInsets.only(top: screenHeight / 6),
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Lottie.asset(
                      'assets/no_records.json',
                      width: screenWidth * 0.6,
                      height: screenHeight * 0.4,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "No FollowUps found",
                      style: TextStyle(
                        fontFamily: 'LeagueSpartan',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ])),
            )
          : SingleChildScrollView(
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
                        _buildInfoCard(
                            'Camp Date', widget.campData['campDate']),
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
                      sectionTitle: 'Added Follow Ups Info',
                      children: [
                        _buildInfoCard(
                            'Follow up Info', widget.campData['followInfo']),
                        _buildInfoCard('Follow up Remarks',
                            widget.campData['followRemark']),
                      ],
                    ),
                    SizedBox(height: 20),
                    CustomButton(
                        text: 'Done',
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ],
                ),
              ),
            ),
    ));
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
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'LeagueSpartan',
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Status: ${patient['status'] ?? 'N/A'}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
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
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'LeagueSpartan',
          ),
        ),
      ),
    );
  }
}
