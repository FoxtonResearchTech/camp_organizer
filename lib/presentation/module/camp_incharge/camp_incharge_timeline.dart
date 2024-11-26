import 'package:camp_organizer/bloc/AddEvent/incharge_report_bloc.dart';
import 'package:camp_organizer/bloc/AddEvent/incharge_report_state.dart';
import 'package:camp_organizer/bloc/Status/status_event.dart';
import 'package:camp_organizer/bloc/approval/onsite_approval_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/AddEvent/incharge_report_event.dart';
import '../../../bloc/Employee/employee_update_event.dart';
import '../../../bloc/Status/status_bloc.dart';
import '../../../bloc/approval/adminapproval_bloc.dart';
import '../../../bloc/approval/adminapproval_event.dart';
import '../../../bloc/approval/adminapproval_state.dart';
import '../../../bloc/approval/onsite_approval_bloc.dart';
import '../../../bloc/approval/onsite_approval_state.dart';
import '../../notification/notification.dart';
import 'camp_incharge_reporting.dart';
import 'incharge_details_page.dart';

class CampInchargeTimeline extends StatefulWidget {
  const CampInchargeTimeline({super.key});

  @override
  State<CampInchargeTimeline> createState() => _CampInchargeTimelineState();
}

class _CampInchargeTimelineState extends State<CampInchargeTimeline> with SingleTickerProviderStateMixin {

  late InchargeReportBloc _inchargeReportBloc;

  @override
  void initState() {
    super.initState();
    _inchargeReportBloc = InchargeReportBloc(firestore: FirebaseFirestore.instance)..add(FetchInchargeReport(employeeId: '', campId: ''));
  }

  @override
  void dispose() {
    _inchargeReportBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // Screen size parameters
    double screenWidth = MediaQuery.of(context).size.width;

    return BlocListener<OnsiteApprovalBloc, OnsiteApprovalState>(
        listener: (context, state) {
          if (state is InchargeReportLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Loading reports...')),
            );
          } else if (state is InchargeReportUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Report updated successfully!')),
            );
          } else if (state is InchargeReportError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${'state.message'}')),
            );
          }
        },
      child: BlocProvider(
      create: (context) => OnsiteApprovalBloc()..add(FetchOnsiteApprovalData()),
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Camp Incharge Reports',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            centerTitle: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue,
                    Colors.lightBlueAccent,
                    Colors.lightBlue
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotificationPage()),
                  );
                },
              ),
            ],
          ),
          body: BlocBuilder<OnsiteApprovalBloc, OnsiteApprovalState>(
            builder: (context, state) {
              if (state is OnsiteApprovalLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is OnsiteApprovalLoaded) {
                final camps = state.allCamps;

                return ListView.builder(
                  itemCount: camps.length,
                  itemBuilder: (context, index) {
                    final camp = camps[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 16.0),
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.date_range,
                                  size: screenWidth * 0.07,
                                  color: Colors.lightBlueAccent,
                                ),
                                const SizedBox(width: 20),
                                Text(
                                  camps[index]['campDate'],
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                const Text(
                                  "Camp Name: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black54,
                                  ),
                                ),
                                Text(
                                  "${camps[index]['campName']}",
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                const Text(
                                  "Document ID: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black54,
                                  ),
                                ),
                                Text(
                                  "${camps[index]['documentId']}",
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                const Text(
                                  "Camp Time: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black54,
                                  ),
                                ),
                                Text(
                                  "${camps[index]['campTime']}",
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      //_showAddCampTeamDialog(
                                      // context, camp['documentId']);
                                      final documentId = camp['documentId'];
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CampInchargeReporting(
                                              documentId: documentId,
                                              campData: camp
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Add Reports',
                                      style: TextStyle(
                                          color: Colors.black87, fontSize: 19),
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.lightBlueAccent), // Set the background color
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),

                                Expanded(
                                  child: ElevatedButton(

                                    onPressed: () {
                                          Navigator.push(context,MaterialPageRoute(
                                          builder: (context) => InchargeDetailsPage(
                                              inchargeData: camp),
                                            ),
                                          );
                                      print(camp);
                                    },
                                    child: const Text(
                                      'View Reports',
                                      style: TextStyle(
                                          color: Colors.black87, fontSize: 19),
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.lightBlueAccent), // Set the background color
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else if (state is AdminApprovalError) {
                return Center(
                  child: Text(
                    '$state.errorMessage',
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                );
              } else {
                return const Center(
                  child: Text('No Camps Found'),
                );
              }
            },
          ),
        ),
    ),
    );
  }
}
