import 'dart:convert';

import 'package:camp_organizer/presentation/Admin/admin_camp_search_screen.dart';
import 'package:camp_organizer/presentation/notification/notification.dart';
import 'package:camp_organizer/utils/app_colors.dart';
import 'package:camp_organizer/widgets/button/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../bloc/Status/status_bloc.dart';
import '../../bloc/Status/status_event.dart';
import '../../bloc/approval/adminapproval_bloc.dart';
import '../../bloc/approval/adminapproval_event.dart';
import '../../bloc/approval/adminapproval_state.dart';
import '../Event/admin_event_details.dart';
import 'package:http/http.dart' as http;

class AdminApproval extends StatefulWidget {
  @override
  State<AdminApproval> createState() => _AdminApprovalState();
}

class _AdminApprovalState extends State<AdminApproval>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late final TextEditingController _reason;
  late StatusBloc _StatusBloc;

  @override
  void initState() {
    super.initState();
    _reason = TextEditingController();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _StatusBloc = StatusBloc()..add(FetchDataEvent());
  }

  @override
  void dispose() {
    _controller.dispose();
    _reason.dispose();
    _StatusBloc.close();
    super.dispose();
  }

  Future<void> sendRejectionEmail(
      String employeeId,
      String campDocId,
      List<dynamic> destId,
      String reason,
      String campname,
      String campdate) async {
    const String serviceId = 'service_m66gp4c';
    const String templateId = 'template_02yy857';
    const String user_id = 'zA3pjW03a2sLLo51c'; // Public Key (user_id)
    const String privateKey = 'K2p5DmTapkR6qYcMPGhTQ'; // Private Key (API Key)

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer $privateKey', // Send the private key as Bearer token
      },
      body: jsonEncode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': user_id,
        'template_params': {
          'to_email': destId, // Recipient's email
          'employeeId': employeeId,
          'campDocId': campDocId,
          'campName': campname,
          'campDate': campdate,
          'status': 'Rejected',
          'reason': reason,
        },
      }),
    );

    if (response.statusCode == 200) {
      print('Email sent successfully!');
    } else {
      print('Failed to send email: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Screen size parameters
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => AdminApprovalBloc()..add(FetchDataEvents()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Status',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'LeagueSpartan',
            ),
          ),
          centerTitle: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.lightBlueAccent, Colors.lightBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdminCampSearchScreen()),
                  );
                },
                icon: const Icon(Icons.search, color: Colors.white)),
          ],
        ),
        body: BlocBuilder<AdminApprovalBloc, AdminApprovalState>(
          builder: (context, state) {
            if (state is AdminApprovalLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AdminApprovalLoaded) {
              final camps = state.allCamps;

              final waitingCamps = camps
                  .where((camp) => camp['campStatus'] == 'Waiting')
                  .toList();
              // Check if there are no camps with status "Waiting"
              return Padding(
                  padding: const EdgeInsets.all(16.0),
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
                            itemBuilder: (BuildContext context, int index) {
                              //  print("doc Id:${state.employeeDocId[2]}");
                              Animation<double> animation = CurvedAnimation(
                                parent: _controller,
                                curve: Interval(
                                  (1 / 5) *
                                      index, // Animate each item sequentially
                                  1.0,
                                  curve: Curves.easeOut,
                                ),
                              );
                              _controller
                                  .forward(); // Start the animation when building

                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(
                                        0, 0.2), // Start slightly below
                                    end:
                                        Offset.zero, // End at original position
                                  ).animate(animation),
                                  child: camps[index]['campStatus'] == 'Waiting'
                                      ? Column(
                                          children: [
                                            // Information Container
                                            Container(
                                              height: screenHeight >= 973
                                                  ? screenHeight / 4
                                                  : screenHeight /
                                                      3.5, // Responsive height
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
                                                              size: screenWidth *
                                                                  0.07, // Responsive icon size
                                                              color: Colors
                                                                  .orange, // Icon color
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
                                                                fontFamily:
                                                                    'LeagueSpartan',
                                                                color: Colors
                                                                    .black54,
                                                                fontSize:
                                                                    screenWidth *
                                                                        0.05, // Responsive font size
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons.watch_later,
                                                              size: screenWidth *
                                                                  0.07, // Responsive icon size
                                                              color: Colors
                                                                  .orange, // Icon color
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
                                                                fontFamily:
                                                                    'LeagueSpartan',
                                                                color: Colors
                                                                    .black54,
                                                                fontSize:
                                                                    screenWidth *
                                                                        0.05, // Responsive font size
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
                                                    const SizedBox(height: 5),
                                                    Container(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          SizedBox(
                                                            width:
                                                                screenWidth / 3,
                                                            height:
                                                                screenHeight /
                                                                    20,
                                                            child:
                                                                ElevatedButton
                                                                    .icon(
                                                              icon: const Icon(
                                                                  Icons.cancel),
                                                              onPressed: () {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AlertDialog(
                                                                      title:
                                                                          Text(
                                                                        'Reason',
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .w500,
                                                                            fontFamily:
                                                                                'LeagueSpartan',
                                                                            color:
                                                                                Colors.black54,
                                                                            fontSize: screenWidth * 0.05 // Responsive font size
                                                                            ),
                                                                      ),
                                                                      content:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          Text(
                                                                            'Please provide a reason for rejection:',
                                                                            style:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.black54,
                                                                              fontFamily: 'LeagueSpartan',
                                                                              fontSize: screenWidth * 0.04, // Responsive font size
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                              height: 10),
                                                                          TextField(
                                                                            controller:
                                                                                _reason,
                                                                            decoration:
                                                                                InputDecoration(
                                                                              hintText: 'Enter reason',
                                                                              suffixStyle: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                color: Colors.black54,
                                                                                fontFamily: 'LeagueSpartan',
                                                                                fontSize: screenWidth * 0.10, // Responsive font size
                                                                              ),
                                                                              border: const OutlineInputBorder(),
                                                                            ),
                                                                            maxLines:
                                                                                null,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      actions: [
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child:
                                                                              const Text(
                                                                            'Cancel',
                                                                            style:
                                                                                TextStyle(
                                                                              color: AppColors.accentBlue,
                                                                              fontFamily: 'LeagueSpartan',
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        TextButton(
                                                                          onPressed:
                                                                              () async {
                                                                            final employeeId =
                                                                                camps[index]['EmployeeDocId'];
                                                                            final campDocId =
                                                                                state.campDocIds[index];
                                                                            final dest1 =
                                                                                'foxton.rt@gmail.com';
                                                                            final dest2 =
                                                                                camps[index]['EmployeeId'];
                                                                            final destId =
                                                                                [
                                                                              dest1,
                                                                              dest2
                                                                            ];
                                                                            final reason =
                                                                                _reason.text;
                                                                            final campname =
                                                                                camps[index]['campName'];
                                                                            final campdate =
                                                                                camps[index]['campDate'];

                                                                            BlocProvider.of<AdminApprovalBloc>(context).add(
                                                                              UpdateStatusEvent(
                                                                                employeeId: employeeId,
                                                                                campDocId: campDocId,
                                                                                newStatus: 'Rejected',
                                                                              ),
                                                                            );
                                                                            // Send email notification
                                                                            await sendRejectionEmail(
                                                                                employeeId,
                                                                                campDocId,
                                                                                destId,
                                                                                reason,
                                                                                campname,
                                                                                campdate);
                                                                            print(employeeId);
                                                                            print(campDocId);
                                                                            print(camps[index]['EmployeeId']);
                                                                            print(_reason.text);
                                                                            try {
                                                                              BlocProvider.of<AdminApprovalBloc>(context).add(
                                                                                UpdateStatusEvent(
                                                                                  employeeId: camps[index]['EmployeeDocId'],
                                                                                  campDocId: state.campDocIds[index],
                                                                                  newStatus: 'Rejected',
                                                                                ),
                                                                              );
                                                                              String reasonText = _reason.text;
                                                                              BlocProvider.of<AdminApprovalBloc>(context).add(
                                                                                AddReasonEvent(
                                                                                  reasonText: reasonText,
                                                                                  employeeId: camps[index]['EmployeeDocId'],
                                                                                  campDocId: state.campDocIds[index],
                                                                                ),
                                                                              );
                                                                              _reason.clear();
                                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                                const SnackBar(
                                                                                  content: Center(
                                                                                    child: Text('Camp Rejected', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500)),
                                                                                  ),
                                                                                  backgroundColor: AppColors.lightRed,
                                                                                ),
                                                                              );
                                                                              Navigator.of(context).pop();
                                                                            } catch (e) {
                                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                                const SnackBar(
                                                                                  content: Center(
                                                                                    child: Text('Failed to Reject ', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500)),
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            }
                                                                          },
                                                                          child:
                                                                              const Text(
                                                                            'Submit',
                                                                            style:
                                                                                TextStyle(
                                                                              color: AppColors.accentBlue,
                                                                              fontFamily: 'LeagueSpartan',
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                iconColor:
                                                                    Colors.red,
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        5,
                                                                    vertical:
                                                                        5),
                                                                backgroundColor:
                                                                    AppColors
                                                                        .lightRed,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                              ),
                                                              label: const Text(
                                                                " Reject",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    color: Colors
                                                                        .white,
                                                                    fontFamily:
                                                                        'LeagueSpartan',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 50),
                                                          Flexible(
                                                            child: SizedBox(
                                                              width:
                                                                  screenWidth /
                                                                      3,
                                                              height:
                                                                  screenHeight /
                                                                      20,
                                                              child:
                                                                  ElevatedButton
                                                                      .icon(
                                                                icon: const Icon(
                                                                    Icons
                                                                        .view_list),
                                                                onPressed:
                                                                    () async {
                                                                  await Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              AdminEventDetailsPage(
                                                                        employeemail:
                                                                            camps[index]['EmployeeId'],
                                                                        campDate:
                                                                            camps[index]['campDate'],
                                                                        campName:
                                                                            camps[index]['campName'],
                                                                        employeeID:
                                                                            camps[index]['EmployeeDocId'],
                                                                        campID:
                                                                            state.campDocIds[index],
                                                                        employee:
                                                                            camps[index],
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  iconColor:
                                                                      Colors
                                                                          .white,
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          5,
                                                                      vertical:
                                                                          5),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .grey,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                  ),
                                                                ),
                                                                label:
                                                                    const Text(
                                                                  " View",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      color: Colors
                                                                          .white,
                                                                      fontFamily:
                                                                          'LeagueSpartan',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            const SizedBox(height: 20),
                                          ],
                                        )
                                      : const SizedBox(),
                                ),
                              );
                            },
                          ),
                  ));
            } else if (state is AdminApprovalError) {
              return const Center(
                child: Text(
                  'Error',
                  style: TextStyle(
                    fontFamily: 'LeagueSpartan',
                  ),
                ),
              );
            }
            return const Center(
              child: Text(
                "No data available",
                style: TextStyle(
                  fontFamily: 'LeagueSpartan',
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Helper method to build timeline tile with responsive styles
  Widget _buildTimelineTile({
    required Color color,
    required IconData icon,
    required String text,
    required double screenWidth,
    Color? lineBeforeColor,
    Color? lineAfterColor,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return TimelineTile(
      axis: TimelineAxis.horizontal,
      alignment: TimelineAlign.center,
      isFirst: isFirst,
      isLast: isLast,
      indicatorStyle: IndicatorStyle(
        width: screenWidth * 0.09, // Increased indicator size
        color: color,
        iconStyle: IconStyle(
          iconData: icon,
          color: Colors.white,
          fontSize: screenWidth * 0.05, // Increased icon size
        ),
      ),
      endChild: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8.0),
        // Adjusted padding
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black54,
            fontFamily: 'LeagueSpartan',
            fontSize:
                screenWidth * 0.05, // Increased font size for timeline text
          ),
        ),
      ),
      beforeLineStyle:
          LineStyle(color: lineBeforeColor ?? Colors.grey, thickness: 3),
      // Slightly thicker lines
      afterLineStyle:
          LineStyle(color: lineAfterColor ?? Colors.grey, thickness: 3),
    );
  }

  // Helper method to build info text with responsive font size
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
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    ];
  }
}
