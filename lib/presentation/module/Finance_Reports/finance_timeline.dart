import 'package:camp_organizer/bloc/AddEvent/add_finance_bloc.dart';
import 'package:camp_organizer/connectivity_checker.dart';
import 'package:camp_organizer/presentation/Event/event_details.dart';
import 'package:camp_organizer/presentation/module/Finance_Reports/finance_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../../bloc/AddEvent/add_finance_state.dart';
import '../../../bloc/Status/status_bloc.dart';
import '../../../bloc/Status/status_event.dart';
import '../../../bloc/approval/adminapproval_bloc.dart';
import '../../../bloc/approval/adminapproval_event.dart';
import '../../../bloc/approval/adminapproval_state.dart';
import '../../notification/notification.dart';
import 'finance_add_expense.dart';

class FinanceTimeline extends StatefulWidget {
  const FinanceTimeline({super.key});

  @override
  State<FinanceTimeline> createState() => _FinanceTimelineState();
}

class _FinanceTimelineState extends State<FinanceTimeline>
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
    //double screenWidth = MediaQuery.of(context).size.width;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return ConnectivityChecker(
        child: BlocListener<AddFinanceBloc, AddFinanceState>(
      listener: (context, state) {
        if (state is AddFinanceLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Center(child: Text('Loading Finance Details...')),
              backgroundColor: Colors.orange,
            ),
          );
        } else if (state is AddFinanceSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Center(child: Text('Finance Details Loaded successfully!')),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is AddFinanceError) {
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
              'Camp Finance Status',
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
          body: BlocBuilder<AdminApprovalBloc, AdminApprovalState>(
            builder: (context, state) {
              if (state is AdminApprovalLoading) {
                return Center(
                    child: CircularProgressIndicator(color: Color(0xFF0097b2)));
              } else if (state is AdminApprovalLoaded) {
                final camps = state.allCamps;
                final waitingCamps = camps
                    .where((camp) => camp['campStatus'] == 'Approved')
                    .toList();
                // Check if there are no camps with status "Waiting"

                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      // Trigger the refresh event in your bloc or reload the data here
                      context.read<AdminApprovalBloc>().add(FetchDataEvents());
                    },
                    child: waitingCamps.isEmpty
                        ? SingleChildScrollView(
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
                            ),
                          )
                        : ListView.builder(
                            itemCount: camps.length,
                            itemBuilder: (context, index) {
                              final camp = camps[index];
                              return GestureDetector(
                                onTap: () async {
                                  // Add debug logs to check the employee data and IDs being passed
                                  print('Employee: ${camps[index]}');
                                  print(
                                      'Employee Doc ID: ${state.employeeDocId[index]}');
                                  print(
                                      'Camp Doc ID: ${state.campDocIds[index]}');

                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EventDetailsPage(
                                        employee: camps[index],
                                        employeedocId: camps[index]
                                            ['EmployeeDocId'],
                                        campId: state.campDocIds[index],
                                      ),
                                    ),
                                  );
                                },
                                child: camps[index]['campStatus'] == "Approved"
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              height: screenHeight /
                                                  3, // Responsive height
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    spreadRadius: 2,
                                                    blurRadius: 10,
                                                    offset: const Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons.date_range,
                                                              size:
                                                                  screenWidth *
                                                                      0.07,
                                                              color:
                                                                  Colors.orange,
                                                            ),
                                                            const SizedBox(
                                                                width: 8),
                                                            Text(
                                                              camps[index]
                                                                  ['campDate'],
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .black54,
                                                                fontFamily:
                                                                    'LeagueSpartan',
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
                                                                  screenWidth *
                                                                      0.07,
                                                              color:
                                                                  Colors.orange,
                                                            ),
                                                            const SizedBox(
                                                                width: 8),
                                                            Text(
                                                              camps[index]
                                                                  ['campTime'],
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .black54,
                                                                fontFamily:
                                                                    'LeagueSpartan',
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
                                                      camps[index]
                                                          ['phoneNumber1'],
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
                                                                  camp[
                                                                      'documentId'];
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          FinanceAddExpense(
                                                                    documentId:
                                                                        documentId,
                                                                    campData:
                                                                        camp,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  Colors
                                                                      .blueAccent, // Vibrant blue for "Add Finance"
                                                              elevation: 5,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20), // Rounded corners
                                                              ),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          15),
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: const [
                                                                Icon(Icons.add,
                                                                    color: Colors
                                                                        .white), // Add icon
                                                                SizedBox(
                                                                    width: 8),
                                                                Text(
                                                                  'Add Finance',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontFamily:
                                                                        'LeagueSpartan',
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        Expanded(
                                                          child: ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      FinanceDetails(
                                                                          campData:
                                                                              camp),
                                                                ),
                                                              );
                                                              print(camp);
                                                            },
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor: Colors
                                                                  .greenAccent
                                                                  .shade700, // Vibrant green for "View Finance"
                                                              elevation: 5,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20), // Rounded corners
                                                              ),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          15),
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: const [
                                                                Icon(
                                                                    Icons
                                                                        .visibility,
                                                                    color: Colors
                                                                        .white), // View icon
                                                                SizedBox(
                                                                    width: 8),
                                                                Text(
                                                                  'View Finance',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontFamily:
                                                                        'LeagueSpartan',
                                                                    fontSize:
                                                                        18,
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
                          ),
                  ),
                );
              } else if (state is AdminApprovalError) {
                return Center(
                  child: Text(
                    '$state.errorMessage',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontFamily: 'LeagueSpartan',
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: Text(
                    'No Camps Found',
                    style: TextStyle(
                      fontFamily: 'LeagueSpartan',
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    ));
  }

  void _showAddCampTeamDialog(BuildContext context, String documentId) {
    final TextEditingController teamController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Add Team',
          style: TextStyle(
            fontFamily: 'LeagueSpartan',
          ),
        ),
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
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'LeagueSpartan',
              ),
            ),
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
            child: const Text(
              'Add',
              style: TextStyle(
                fontFamily: 'LeagueSpartan',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addTeamToCamp(dynamic camp, String teamInfo) {
    // Logic to add team information to the selected camp
    print('Team "$teamInfo" added to camp: ${camp.name},');
    // Integrate with your bloc or backend logic here
  }

  List<Widget> _buildInfoText(double screenWidth, String text) {
    return [
      Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black54,
          fontFamily: 'LeagueSpartan',
          fontSize: screenWidth * 0.05, // Responsive font size
        ),
      ),
    ];
  }
}
