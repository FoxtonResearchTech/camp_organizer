import 'package:camp_organizer/bloc/AddEvent/add_logistics_bloc.dart';
import 'package:camp_organizer/bloc/AddEvent/add_logistics_state.dart';
import 'package:camp_organizer/presentation/Event/event_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/Status/status_bloc.dart';
import '../../../bloc/Status/status_event.dart';
import '../../../bloc/approval/adminapproval_bloc.dart';
import '../../../bloc/approval/adminapproval_event.dart';
import '../../../bloc/approval/adminapproval_state.dart';
import '../../notification/notification.dart';
import 'inward_details.dart';
import 'logistics_inward.dart';
import 'logistics_outward.dart';
import 'outward_details.dart';

class LogisticsTimeline extends StatefulWidget {
  const LogisticsTimeline({super.key});

  @override
  State<LogisticsTimeline> createState() => _LogisticsTimelineState();
}

class _LogisticsTimelineState extends State<LogisticsTimeline>
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
    // double screenWidths = MediaQuery.of(context).size.width;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return BlocListener<AddLogisticsBloc, AddLogisticsState>(
      listener: (context, state) {
        if (state is AddLogisticsLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Center(child: Text('Adding Logistics...')),
              backgroundColor: Colors.orange,
            ),
          );
        } else if (state is AddLogisticsSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Center(child: Text('Logistics added successfully!')),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is AddLogisticsError) {
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
              'Logistics Timeline',
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
                                            2.5, // Responsive height
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
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        final documentId =
                                                            camp['documentId'];
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                LogisticsOutward(
                                                                    documentId:
                                                                        documentId,
                                                                    campData:
                                                                        camp),
                                                          ),
                                                        );
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: const [
                                                          Icon(Icons.outbox,
                                                              color: Colors
                                                                  .white), // Icon for "Outward"
                                                          SizedBox(width: 8),
                                                          Text(
                                                            'Outward',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      ),
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .lightBlueAccent),
                                                        foregroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .white),
                                                        shadowColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .blueAccent),
                                                        elevation:
                                                            MaterialStateProperty
                                                                .all(5),
                                                        shape:
                                                            MaterialStateProperty
                                                                .all(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                        ),
                                                        padding:
                                                            MaterialStateProperty.all(
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        15)),
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
                                                                LogisticsOutwardPage(
                                                                    campData:
                                                                        camp),
                                                          ),
                                                        );
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: const [
                                                          Icon(Icons.details,
                                                              color: Colors
                                                                  .white), // Icon for "View Details"
                                                          SizedBox(width: 8),
                                                          Text(
                                                            'View Details',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      ),
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .tealAccent),
                                                        foregroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .white),
                                                        shadowColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .teal),
                                                        elevation:
                                                            MaterialStateProperty
                                                                .all(5),
                                                        shape:
                                                            MaterialStateProperty
                                                                .all(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                        ),
                                                        padding:
                                                            MaterialStateProperty.all(
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        15)),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 20),
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
                                                                LogisticsInward(
                                                                    documentId:
                                                                        documentId,
                                                                    campData:
                                                                        camp),
                                                          ),
                                                        );
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: const [
                                                          Icon(Icons.inbox,
                                                              color: Colors
                                                                  .white), // Icon for "Inward"
                                                          SizedBox(width: 8),
                                                          Text(
                                                            'Inward',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      ),
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .pinkAccent),
                                                        foregroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .white),
                                                        shadowColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .pink),
                                                        elevation:
                                                            MaterialStateProperty
                                                                .all(5),
                                                        shape:
                                                            MaterialStateProperty
                                                                .all(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                        ),
                                                        padding:
                                                            MaterialStateProperty.all(
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        15)),
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
                                                                InwardDetails(
                                                                    campData:
                                                                        camp),
                                                          ),
                                                        );
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: const [
                                                          Icon(Icons.info,
                                                              color: Colors
                                                                  .white), // Icon for "View Details"
                                                          SizedBox(width: 8),
                                                          Text(
                                                            'View Details',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      ),
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .orangeAccent),
                                                        foregroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .white),
                                                        shadowColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .orange),
                                                        elevation:
                                                            MaterialStateProperty
                                                                .all(5),
                                                        shape:
                                                            MaterialStateProperty
                                                                .all(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                        ),
                                                        padding:
                                                            MaterialStateProperty.all(
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        15)),
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
