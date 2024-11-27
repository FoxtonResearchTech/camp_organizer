import 'package:camp_organizer/bloc/AddEvent/incharge_report_bloc.dart';
import 'package:camp_organizer/bloc/AddEvent/incharge_report_state.dart';
import 'package:camp_organizer/bloc/Status/status_event.dart';
import 'package:camp_organizer/bloc/approval/onsite_approval_event.dart';
import 'package:camp_organizer/presentation/Event/event_details.dart';
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
   // double screenWidth = MediaQuery.of(context).size.width;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
                    return GestureDetector(
                      onTap: () async {
                        // Add debug logs to check the employee data and IDs being passed
                        print('Employee: ${camps[index]}');
                        print(
                            'Employee Doc ID: ${state.employeeDocId[index]}');
                        print('Camp Doc ID: ${state.campDocIds[index]}');

                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventDetailsPage(
                              employee: camps[index],
                              employeedocId:  camps[index]
                              ['EmployeeDocId'],
                              campId: state.campDocIds[index],
                            ),
                          ),
                        );
                      },
                      child: camps[index]
                      ['campStatus'] ==
                          "Approved"
                          ?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height:
                              screenHeight / 3.2, // Responsive height
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.date_range,
                                              size: screenWidth * 0.07,
                                              color: Colors.orange,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              camps[index]
                                              ['campDate'],
                                              style: TextStyle(
                                                fontWeight:
                                                FontWeight.w500,
                                                color: Colors.black54,
                                                fontSize:
                                                screenWidth * 0.05,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.watch_later,
                                              size: screenWidth * 0.07,
                                              color: Colors.orange,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              camps[index]
                                              ['campTime'],
                                              style: TextStyle(
                                                fontWeight:
                                                FontWeight.w500,
                                                color: Colors.black54,
                                                fontSize:
                                                screenWidth * 0.05,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    ..._buildInfoText(
                                      screenWidth,
                                      camps[index]['campName'],
                                    ),
                                    ..._buildInfoText(
                                      screenWidth,
                                      camps[index]['address'],
                                    ),
                                    ..._buildInfoText(
                                      screenWidth,
                                      camps[index]['name'],
                                    ),
                                    ..._buildInfoText(
                                      screenWidth,
                                      camps[index]['phoneNumber1'],
                                    ),
                                    SizedBox(height: 20,),
                                    // Horizontal Timeline Container

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              final documentId = camp['documentId'];
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => CampInchargeReporting(
                                                    documentId: documentId,
                                                    campData: camp,
                                                  ),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.lightBlueAccent,
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              padding: const EdgeInsets.symmetric(vertical: 15),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: const [
                                                Icon(Icons.add_chart, color: Colors.white), // Add icon
                                                SizedBox(width: 8),
                                                Text(
                                                  'Add Reports',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => InchargeDetailsPage(inchargeData: camp),
                                                ),
                                              );
                                              print(camp);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.deepOrangeAccent, // Vibrant orange color
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              padding: const EdgeInsets.symmetric(vertical: 15),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: const [
                                                Icon(Icons.view_list, color: Colors.white), // View icon
                                                SizedBox(width: 8),
                                                Text(
                                                  'View Reports',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),




                                  ],
                                ),
                              ),
                            ),
                          ),

                        ],
                      ) : Center(

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
  List<Widget> _buildInfoText(double screenWidth, String text) {
    return [
      Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black54,
          fontSize: screenWidth * 0.05, // Responsive font size
        ),
      ),
    ];
  }
}
