import 'package:camp_organizer/bloc/Status/status_bloc.dart';
import 'package:camp_organizer/bloc/Status/status_event.dart';
import 'package:camp_organizer/bloc/Status/status_state.dart';
import 'package:camp_organizer/presentation/Event/event_details.dart';
import 'package:camp_organizer/presentation/notification/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeline_tile/timeline_tile.dart';

import 'CampSearchScreen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late StatusBloc _StatusBloc;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _StatusBloc = StatusBloc()..add(FetchDataEvent());
  }

  @override
  void dispose() {
    _controller.dispose();
    _StatusBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Screen size parameters
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => _StatusBloc,
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Camp Status',
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CampSearchScreen()),
                    );
                  },
                  icon: const Icon(Icons.search, color: Colors.white)),
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationPage()));
                },
              ),
            ],
          ),
          body: BlocBuilder<StatusBloc, StatusState>(
            builder: (context, state) {
              if (state is StatusLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is StatusLoaded) {
                final employees = state.employees;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      // Trigger the refresh event in your bloc or reload the data here
                      context.read<StatusBloc>().add(FetchDataEvent());
                    },
                    child: ListView.builder(
                      itemCount: employees.length,
                      itemBuilder: (BuildContext context, int index) {
                        Animation<double> animation = CurvedAnimation(
                          parent: _controller,
                          curve: Interval(
                            (1 / 5) * index, // Animate each item sequentially
                            1.0,
                            curve: Curves.easeOut,
                          ),
                        );
                        _controller
                            .forward(); // Start the animation when building

                        return GestureDetector(
                          onTap: () async {
                            // Add debug logs to check the employee data and IDs being passed
                            print('Employee: ${employees[index]}');
                            print(
                                'Employee Doc ID: ${state.employeeDocId[index]}');
                            print('Camp Doc ID: ${state.campDocId[index]}');

                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EventDetailsPage(
                                  employee: employees[index],
                                  employeedocId: state.employeeDocId[index],
                                  campId: state.campDocId[index],
                                ),
                              ),
                            );
                          },
                          child: FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(
                                    0, 0.2), // Start slightly below
                                end: Offset.zero, // End at original position
                              ).animate(animation),
                              child: Column(
                                children: [
                                  // Information Container
                                  Container(
                                    height:
                                        screenHeight / 3, // Responsive height
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
                                                    employees[index]
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
                                                    employees[index]
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
                                            employees[index]['campName'],
                                          ),
                                          ..._buildInfoText(
                                            screenWidth,
                                            employees[index]['address'],
                                          ),
                                          ..._buildInfoText(
                                            screenWidth,
                                            employees[index]['name'],
                                          ),
                                          ..._buildInfoText(
                                            screenWidth,
                                            employees[index]['phoneNumber1'],
                                          ),
                                          // Horizontal Timeline Container
                                          employees[index]['campStatus'] ==
                                                  "Waiting"
                                              ? Container(
                                                  height: screenHeight * 0.1,
                                                  width: double.infinity,
                                                  child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Row(
                                                      children: [
                                                        _buildTimelineTile(
                                                          isFirst: true,
                                                          color: Colors
                                                              .yellow[700]!,
                                                          icon: Icons.check,
                                                          text: 'Processing',
                                                          screenWidth:
                                                              screenWidth,
                                                          lineBeforeColor:
                                                              Colors.grey,
                                                          lineAfterColor:
                                                              Colors.grey,
                                                        ),
                                                        _buildTimelineTile(
                                                          color:
                                                              Colors.blue[600]!,
                                                          icon: Icons.pending,
                                                          text: 'Confirmed',
                                                          screenWidth:
                                                              screenWidth,
                                                          lineBeforeColor:
                                                              Colors.grey,
                                                          lineAfterColor:
                                                              Colors.grey,
                                                        ),
                                                        _buildTimelineTile(
                                                          isLast: true,
                                                          color:
                                                              Colors.grey[400]!,
                                                          icon: Icons.circle,
                                                          text: 'Completed',
                                                          screenWidth:
                                                              screenWidth,
                                                          lineBeforeColor:
                                                              Colors.grey,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : employees[index]
                                                          ['campStatus'] ==
                                                      "Approved"
                                                  ? Container(
                                                      height:
                                                          screenHeight * 0.1,
                                                      width: double.infinity,
                                                      child:
                                                          SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: Row(
                                                          children: [
                                                            _buildTimelineTile(
                                                              isFirst: true,
                                                              color: Colors
                                                                  .yellow[700]!,
                                                              icon: Icons.check,
                                                              text:
                                                                  'Processing',
                                                              screenWidth:
                                                                  screenWidth,
                                                              lineBeforeColor:
                                                                  Colors.green,
                                                              lineAfterColor:
                                                                  Colors.green,
                                                            ),
                                                            _buildTimelineTile(
                                                              color: Colors
                                                                  .blue[600]!,
                                                              icon:
                                                                  Icons.pending,
                                                              text: 'Confirmed',
                                                              screenWidth:
                                                                  screenWidth,
                                                              lineBeforeColor:
                                                                  Colors.green,
                                                              lineAfterColor:
                                                                  Colors.grey,
                                                            ),
                                                            _buildTimelineTile(
                                                              isLast: true,
                                                              color: Colors
                                                                  .grey[400]!,
                                                              icon:
                                                                  Icons.circle,
                                                              text: 'Completed',
                                                              screenWidth:
                                                                  screenWidth,
                                                              lineBeforeColor:
                                                                  Colors.grey,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : Container(
                                                      height:
                                                          screenHeight * 0.1,
                                                      width: double.infinity,
                                                      child:
                                                          SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: Row(
                                                          children: [
                                                            _buildTimelineTile(
                                                              isFirst: true,
                                                              color: Colors
                                                                  .yellow[700]!,
                                                              icon: Icons.check,
                                                              text:
                                                                  'Processing',
                                                              screenWidth:
                                                                  screenWidth,
                                                              lineBeforeColor:
                                                                  Colors.green,
                                                              lineAfterColor:
                                                                  Colors.green,
                                                            ),
                                                            _buildTimelineTile(
                                                              color: Colors
                                                                  .blue[600]!,
                                                              icon:
                                                                  Icons.pending,
                                                              text: 'Confirmed',
                                                              screenWidth:
                                                                  screenWidth,
                                                              lineBeforeColor:
                                                                  Colors.green,
                                                              lineAfterColor:
                                                                  Colors.green,
                                                            ),
                                                            _buildTimelineTile(
                                                              isLast: true,
                                                              color: Colors
                                                                  .grey[400]!,
                                                              icon:
                                                                  Icons.circle,
                                                              text: 'Completed',
                                                              screenWidth:
                                                                  screenWidth,
                                                              lineBeforeColor:
                                                                  Colors.green,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              } else if (state is StatusError) {
                return Center(
                  child: Text('Error: ${state.errorMessage}'),
                );
              }
              return Center(
                child: Text("No data available"),
              );
            },
          )),
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
          fontSize: screenWidth * 0.05, // Responsive font size
        ),
      ),
    ];
  }
}
