import 'package:camp_organizer/bloc/AddEvent/incharge_report_bloc.dart';
import 'package:camp_organizer/bloc/AddEvent/incharge_report_state.dart';
import 'package:camp_organizer/bloc/Status/status_event.dart';
import 'package:camp_organizer/bloc/approval/onsite_approval_event.dart';
import 'package:camp_organizer/presentation/Event/event_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

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
import 'package:firebase_auth/firebase_auth.dart';

class CampInchargeTimeline extends StatefulWidget {
  const CampInchargeTimeline({super.key});

  @override
  State<CampInchargeTimeline> createState() => _CampInchargeTimelineState();
}

class _CampInchargeTimelineState extends State<CampInchargeTimeline>
    with SingleTickerProviderStateMixin {
  late InchargeReportBloc _inchargeReportBloc;

  @override
  void initState() {
    super.initState();
    _inchargeReportBloc =
        InchargeReportBloc(firestore: FirebaseFirestore.instance)
          ..add(FetchInchargeReport(employeeId: '', campId: ''));
    fetchEmployeeName();
  }

  @override
  void dispose() {
    _inchargeReportBloc.close();
    super.dispose();
  }

  String? employeeName;

  Future<void> fetchEmployeeName() async {
    try {
      // Get the current user's UID from FirebaseAuth
      User? currentUser = FirebaseAuth.instance.currentUser;
      String? currentEmployeeId = currentUser?.uid;

      if (currentEmployeeId == null) {
        setState(() {
          employeeName = 'User not logged in';
          print("Error: $employeeName");
        });
        return;
      }

      // Reference to Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Fetch the document for the current employee using their UID
      DocumentSnapshot employeeDoc =
          await firestore.collection('employees').doc(currentEmployeeId).get();

      if (employeeDoc.exists) {
        // Safely cast the document data to Map<String, dynamic>
        Map<String, dynamic>? data =
            employeeDoc.data() as Map<String, dynamic>?;

        if (data != null) {
          // Access the 'firstName' field
          String? firstName = data['firstName'];

          setState(() {
            employeeName = firstName ?? 'No employee found';
            print("Employee's Name: $employeeName");
          });
        } else {
          setState(() {
            employeeName = 'No data in employee document';
            print("Error: $employeeName");
          });
        }
      } else {
        setState(() {
          employeeName = 'Employee document not found';
          print("Error: $employeeName");
        });
      }
    } catch (e) {
      // Handle exceptions
      setState(() {
        employeeName = 'Error fetching employee name';
        print("Error: $e");
      });
    }
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
            const SnackBar(
              content: Center(child: Text('Loading reports...')),
              backgroundColor: Colors.orange,
            ),
          );
        } else if (state is InchargeReportUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Center(child: Text('Report updated successfully!')),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is InchargeReportError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Center(child: Text('Error: ${'state.message'}')),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocProvider(
        create: (context) =>
            OnsiteApprovalBloc()..add(FetchOnsiteApprovalData()),
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Camp Incharge Reports',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontFamily: 'LeagueSpartan',
                  fontWeight: FontWeight.bold),
            ),
            centerTitle: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Container(
              decoration:  BoxDecoration(
                gradient: LinearGradient(
                  colors: [ Color(0xFF0097b2),  Color(0xFF0097b2).withOpacity(1), Color(0xFF0097b2).withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          body: BlocBuilder<OnsiteApprovalBloc, OnsiteApprovalState>(
            builder: (context, state) {
              if (state is OnsiteApprovalLoading) {
                return const Center(child: CircularProgressIndicator(
                  color: Color(0xFF0097b2),
                ));
              } else if (state is OnsiteApprovalLoaded) {
                final camps = state.allCamps;

                // Filter camps to only include those where the condition is true
                final filteredCamps = camps
                    .where((camp) => employeeName == camp['incharge'])
                    .toList();

                // Check if there are no camps meeting the condition
                if (filteredCamps.isEmpty) {
                  return  Center(
                    child: Container(

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
                            "No Camps found",
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
                  );
                }

                return RefreshIndicator(
                  color: Color(0xFF0097b2),
                  onRefresh: () async {
                    context
                        .read<OnsiteApprovalBloc>()
                        .add(FetchOnsiteApprovalData());
                  },
                  child: ListView.builder(
                    itemCount: filteredCamps.length,
                    itemBuilder: (context, index) {
                      final camp = filteredCamps[index];
                      return GestureDetector(
                        onTap: () async {
                          // Debug logs
                          print('Employee: ${camp}');
                          print(
                              'Employee Doc ID: ${state.employeeDocId[index]}');
                          print('Camp Doc ID: ${state.campDocIds[index]}');

                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventDetailsPage(
                                employee: camp,
                                employeedocId: camp['EmployeeDocId'],
                                campId: state.campDocIds[index],
                              ),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: screenHeight / 3.2,
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
                                      // Display camp details
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
                                                camp['campDate'],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black54,
                                                  fontSize: screenWidth * 0.05,
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
                                                camp['campTime'],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black54,
                                                  fontSize: screenWidth * 0.05,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      ..._buildInfoText(
                                          screenWidth, camp['campName']),
                                      ..._buildInfoText(
                                          screenWidth, camp['address']),
                                      ..._buildInfoText(
                                          screenWidth, camp['name']),
                                      ..._buildInfoText(
                                          screenWidth, camp['phoneNumber1']),
                                      const SizedBox(height: 20),
                                      // Buttons for actions
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                final documentId =
                                                    camp['documentId'];
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        CampInchargeReporting(
                                                      documentId: documentId,
                                                      campData: camp,
                                                    ),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.lightBlueAccent,
                                                elevation: 5,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 15),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Icon(Icons.add_chart,
                                                      color: Colors.white),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    'Add Reports',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                    builder: (context) =>
                                                        InchargeDetailsPage(
                                                      inchargeData: camp,
                                                    ),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.deepOrangeAccent,
                                                elevation: 5,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 15),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Icon(Icons.view_list,
                                                      color: Colors.white),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    'View Reports',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                        ),
                      );
                    },
                  ),
                );
              } else if (state is AdminApprovalError) {
                return Center(
                  child: Text(
                    'Error',
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

  Future<String?> getCurrentEmployeeName() async {
    try {
      // Reference to the Firestore collection
      CollectionReference employees =
          FirebaseFirestore.instance.collection('employees');

      // Query to fetch the employee with role 'campincharge'
      QuerySnapshot querySnapshot = await employees
          .where('role', isEqualTo: 'campIncharge')
          .limit(1) // Limit to one result for current employee
          .get();

      // Check if any documents match the query
      if (querySnapshot.docs.isNotEmpty) {
        // Access the first document and extract the name field
        var employeeData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        return employeeData['firstName'] as String?;
      } else {
        // No employee found
        return null;
      }
    } catch (e) {
      print('Error fetching employee name: $e');
      return null;
    }
  }
}
