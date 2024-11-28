import 'package:camp_organizer/presentation/Event/event_details.dart';
import 'package:camp_organizer/presentation/module/post_camp_followup/post_camp_follow.dart';
import 'package:camp_organizer/presentation/module/post_camp_followup/post_camp_follow_completed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/AddEvent/onsite_add_team_bloc.dart';
import '../../../bloc/AddEvent/onsite_add_team_state.dart';
import '../../../bloc/Status/status_bloc.dart';
import '../../../bloc/Status/status_event.dart';
import '../../../bloc/approval/adminapproval_bloc.dart';
import '../../../bloc/approval/adminapproval_event.dart';
import '../../../bloc/approval/adminapproval_state.dart';
import '../../notification/notification.dart';

class PostCampTimeline extends StatefulWidget {
  const PostCampTimeline({super.key});

  @override
  State<PostCampTimeline> createState() => _PostCampTimelineState();
}

class _PostCampTimelineState extends State<PostCampTimeline>
    with SingleTickerProviderStateMixin {
  late StatusBloc _StatusBloc;
  @override
  void initState() {
    super.initState();
    _StatusBloc = StatusBloc()..add(FetchDataEvent());
  }

  @override
  void dispose() {
    _StatusBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Screen size parameters
    //  double screenWidth = MediaQuery.of(context).size.width;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return BlocListener<AddTeamBloc, AddTeamState>(
      listener: (context, state) {
        if (state is AddTeamLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Center(child: Text('Adding team...')),
              backgroundColor: Colors.orange,
            ),
          );
        } else if (state is AddTeamSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Center(child: Text('Team added successfully!')),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is AddTeamError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Center(child: Text('Error: ${state.message}')),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocProvider(
        create: (context) => AdminApprovalBloc()..add(FetchDataEvents()),
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'FollowUp Camp Timeline',
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
          ),
          body: BlocBuilder<AdminApprovalBloc, AdminApprovalState>(
            builder: (context, state) {
              if (state is AdminApprovalLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is AdminApprovalLoaded) {
                final camps = state.allCamps;

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<AdminApprovalBloc>().add(FetchDataEvents());
                  },
                  child: ListView.builder(
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
                                employeedocId: camps[index]['EmployeeDocId'],
                                campId: state.campDocIds[index],
                              ),
                            ),
                          );
                        },
                        child: camps[index]['campStatus'] == "Approved"
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: screenHeight /
                                          3.2, // Responsive height
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                      camps[index]['campDate'],
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
                                                      camps[index]['campTime'],
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
                                            SizedBox(
                                              height: 20,
                                            ),
                                            // Horizontal Timeline Container

                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                              PostCampFollow(
                                                            documentId:
                                                                documentId,
                                                            campData: camp,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor: Colors
                                                          .indigo, // Stylish indigo color for "Follow Report"
                                                      elevation: 5,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                20), // Rounded corners
                                                      ),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 15),
                                                    ),
                                                    child: const Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                            Icons
                                                                .follow_the_signs,
                                                            color: Colors
                                                                .white), // Follow icon
                                                        SizedBox(width: 8),
                                                        Text(
                                                          'Follow Report',
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
                                                      final documentId =
                                                          camp['documentId'];
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              PostCampFollowCompleted(
                                                            documentId:
                                                                documentId,
                                                            campData: camp,
                                                          ),
                                                        ),
                                                      );
                                                      print(camp);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor: Colors
                                                          .teal, // Teal color for "View Report"
                                                      elevation: 5,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                20), // Rounded corners
                                                      ),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 15),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: const [
                                                        Icon(Icons.visibility,
                                                            color: Colors
                                                                .white), // View icon
                                                        SizedBox(width: 8),
                                                        Text(
                                                          'View Report',
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
                              )
                            : Center(),
                      );
                    },
                  ),
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
