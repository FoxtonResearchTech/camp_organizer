import 'package:camp_organizer/bloc/Status/status_event.dart';
import 'package:camp_organizer/presentation/Event/event_details.dart';
import 'package:camp_organizer/presentation/module/Onsite_Management_team/onsite_camp_details_page.dart';
import 'package:camp_organizer/widgets/button/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/AddEvent/onsite_add_team_bloc.dart';
import '../../../bloc/AddEvent/onsite_add_team_event.dart';
import '../../../bloc/AddEvent/onsite_add_team_state.dart';
import '../../../bloc/Status/status_bloc.dart';
import '../../../bloc/approval/adminapproval_bloc.dart';
import '../../../bloc/approval/adminapproval_event.dart';
import '../../../bloc/approval/adminapproval_state.dart';
import '../../notification/notification.dart';
import 'onsite_team_setup.dart';

class OnsiteCampTimeline extends StatefulWidget {
  const OnsiteCampTimeline({super.key});

  @override
  State<OnsiteCampTimeline> createState() => _OnsiteCampTimelineState();
}

class _OnsiteCampTimelineState extends State<OnsiteCampTimeline>
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
    double screenWidths = MediaQuery.of(context).size.width;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return BlocListener<AddTeamBloc, AddTeamState>(
      listener: (context, state) {
        if (state is AddTeamLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Adding team...')),
          );
        } else if (state is AddTeamSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Team added successfully!')),
          );
        } else if (state is AddTeamError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.message}')),
          );
        }
      },
      child: BlocProvider(
        create: (context) => AdminApprovalBloc()..add(FetchDataEvents()),
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Onsite Camp ',
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
            actions: [],
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
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                                                        size:
                                                            screenWidth * 0.07,
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
                                                              screenWidth *
                                                                  0.05,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.watch_later,
                                                        size:
                                                            screenWidth * 0.07,
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
                                                              screenWidth *
                                                                  0.05,
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
                                                  // Add Team Button
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        final documentId =
                                                            camp['documentId'];
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                OnsiteTeamSetup(
                                                              documentId:
                                                                  documentId,
                                                              campData: camp,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 16),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        backgroundColor: Colors
                                                            .lightBlueAccent,
                                                        shadowColor: Colors.blue
                                                            .withOpacity(0.4),
                                                        elevation: 5,
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Icon(
                                                              Icons.group_add,
                                                              color:
                                                                  Colors.white),
                                                          const SizedBox(
                                                              width: 8),
                                                          const Text(
                                                            'Add Team',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),

                                                  // View Team Button
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                OnsiteCampDetailsPage(
                                                              campData: camp,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 16),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        backgroundColor: Colors
                                                            .tealAccent
                                                            .shade700,
                                                        shadowColor: Colors.teal
                                                            .withOpacity(0.4),
                                                        elevation: 5,
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Icon(
                                                              Icons.visibility,
                                                              color:
                                                                  Colors.white),
                                                          const SizedBox(
                                                              width: 8),
                                                          const Text(
                                                            'View Team',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                    ));
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

  void _showAddCampTeamDialog(BuildContext context, String documentId) {
    final TextEditingController teamController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Team'),
        content: TextField(
          controller: teamController,
          decoration: const InputDecoration(
            labelText: 'Enter Team Information',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              //final teamInfo = teamController.text.trim();
              // if (teamInfo.isNotEmpty) {
              // context.read<AddTeamBloc>().add(
              //  AddTeamWithDocumentId(

              //    documentId: documentId,
              //   teamInfo: teamInfo,
              // ),
              // );
              // Navigator.pop(context);
              //}
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _addTeamToCamp(dynamic camp, String teamInfo) {
    // Logic to add team information to the selected camp
    print('Team "$teamInfo" added to camp: ${camp.name}');
    // Integrate with your bloc or backend logic here
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
