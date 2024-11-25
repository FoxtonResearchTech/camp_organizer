import 'package:camp_organizer/bloc/Status/status_bloc.dart';
import 'package:camp_organizer/bloc/Status/status_event.dart';
import 'package:camp_organizer/bloc/Status/status_state.dart';
import 'package:camp_organizer/presentation/Admin/admin_approval.dart';
import 'package:camp_organizer/presentation/Admin/admin_approval.dart';
import 'package:camp_organizer/presentation/Admin/admin_approval.dart';
import 'package:camp_organizer/presentation/Admin/admin_approval.dart';
import 'package:camp_organizer/presentation/Admin/admin_approval.dart';
import 'package:camp_organizer/presentation/Admin/admin_approval.dart';
import 'package:camp_organizer/presentation/Event/event_details.dart';
import 'package:camp_organizer/presentation/notification/notification.dart';
import 'package:camp_organizer/utils/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:bloc/bloc.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState
    extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  int touchedIndex = -1;
  late AnimationController _controller;
  double rotationAngle = 0;
  late StatusBloc _StatusBloc;
  final List<double> values = [30, 25, 20, 15, 10];
  final List<Color> colors = [
    Colors.blueAccent,
    Colors.orangeAccent,
    Colors.redAccent,
    Colors.greenAccent,
    Colors.purpleAccent,
  ];
  final List<String> titles = [
    'Total Camp Target',
    'Total Camp Initiated',
    'Total Camp Confirmed',
    'Waiting Queue',
    'Total Camp Rejected'
  ];

  @override
  void initState() {
    _StatusBloc = StatusBloc()..add(FetchDataEvent());
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(() {
      setState(() {
        rotationAngle = _controller.value * 360;
      });
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _StatusBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => _StatusBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Dashboard',
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          centerTitle: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.lightBlueAccent, Colors.lightBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications, color: Colors.white),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationPage()));
              },
            ),
          ],
        ),
        drawer: Drawer(
          width: screenWidth / 1.5,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue,
                      Colors.lightBlueAccent,
                      Colors.lightBlue
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.manage_accounts),
                title: Text('Manage Account'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.approval),
                title: Text('New Camp Approval'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.approval),
                title: Text('Onsite Team Approval'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.approval),
                title: Text('Account Approval'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.approval),
                title: Text('Camp Repects Approval'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.approval),
                title: Text('Logestic Approval'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.pending),
                title: Text('Pending Camp Data'),
                onTap: () {},
              ),
            ],
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final pieChartRadius = constraints.maxWidth < 600 ? 120.0 : 180.0;
            final fontSizeFactor = constraints.maxWidth < 600 ? 0.8 : 1.0;
            final gridAspectRatio = constraints.maxWidth < 600 ? 2.0 : 2.5;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AspectRatio(
                      aspectRatio: 1.3,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: PieChart(
                              PieChartData(
                                pieTouchData: PieTouchData(
                                  touchCallback:
                                      (FlTouchEvent event, pieTouchResponse) {
                                    setState(() {
                                      if (!event.isInterestedForInteractions ||
                                          pieTouchResponse == null ||
                                          pieTouchResponse.touchedSection ==
                                              null) {
                                        touchedIndex = -1;
                                        return;
                                      }
                                      touchedIndex = pieTouchResponse
                                          .touchedSection!.touchedSectionIndex;
                                    });
                                  },
                                ),
                                startDegreeOffset: rotationAngle,
                                borderData: FlBorderData(show: false),
                                sectionsSpace: 2,
                                centerSpaceRadius: pieChartRadius - 60,
                                sections: showingSections(
                                    fontSizeFactor, pieChartRadius),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          _buildIndicators(fontSizeFactor),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildDetailsGrid(gridAspectRatio, fontSizeFactor),
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Upcoming Event",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 25,
                          color: Colors.black54),
                    ),
                  ),
                  BlocBuilder<StatusBloc, StatusState>(
                    builder: (context, state) {
                      if (state is StatusLoading) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is StatusLoaded) {
                        final employees = state.employees;

                        return Padding(
                          padding: EdgeInsets.all(16.0),
                          child: SizedBox(
                            height: constraints.maxHeight * 0.6,
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: employees.length,
                              itemBuilder: (BuildContext context, int index) {
                                Animation<double> animation = CurvedAnimation(
                                  parent: _controller,
                                  curve: Interval(
                                    (1 / 5) * index,
                                    1.0,
                                    curve: Curves.easeOut,
                                  ),
                                );
                                _controller.forward();

                                return employees[index]['campStatus'] ==
                                    "Approved"
                                    ? FadeTransition(
                                  opacity: animation,
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: Offset(0, 0.2),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 20),
                                      child: Container(
                                        height: MediaQuery.of(context)
                                            .size
                                            .height *
                                            0.25,
                                        // Set height to 25% of screen height
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
                                                        // Responsive icon size
                                                        color: Colors
                                                            .orange, // Icon color
                                                      ),
                                                      const SizedBox(
                                                          width: 8),
                                                      Text(
                                                        employees[index]
                                                        ['campDate'],
                                                        style: TextStyle(
                                                          fontWeight:
                                                          FontWeight
                                                              .w500,
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
                                                        size:
                                                        screenWidth *
                                                            0.07,
                                                        // Responsive icon size
                                                        color: Colors
                                                            .orange, // Icon color
                                                      ),
                                                      const SizedBox(
                                                          width: 8),
                                                      Text(
                                                        employees[index]
                                                        ['campTime'],
                                                        style: TextStyle(
                                                          fontWeight:
                                                          FontWeight
                                                              .w500,
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
                                                employees[index]
                                                ['campName'],
                                              ),
                                              ..._buildInfoText(
                                                screenWidth,
                                                employees[index]
                                                ['address'],
                                              ),
                                              ..._buildInfoText(
                                                screenWidth,
                                                employees[index]['name'],
                                              ),
                                              ..._buildInfoText(
                                                screenWidth,
                                                employees[index]
                                                ['phoneNumber1'],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                    : SizedBox();
                              },
                            ),
                          ),
                        );
                      } else if (state is StatusError) {
                        return Center(
                          child: Text('Error+${state.errorMessage}'),
                        );
                      }
                      return Center(
                        child: Text("No data available"),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEventDetail(
      IconData icon, String text, BoxConstraints constraints) {
    return Row(
      children: [
        Icon(icon, size: constraints.maxWidth * 0.07, color: Colors.orange),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black54,
            fontSize: constraints.maxWidth * 0.05,
          ),
        ),
      ],
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

  List<PieChartSectionData> showingSections(
      double fontSizeFactor, double radiusFactor) {
    return List.generate(values.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = (isTouched ? 22.0 : 16.0) * fontSizeFactor;
      final radius = (isTouched ? 70.0 : 50.0) * (radiusFactor / 150);

      return PieChartSectionData(
        color: colors[i],
        value: values[i],
        title: '${values[i].toInt()}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }

  Column _buildIndicators(double fontSizeFactor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        return Row(
          children: [
            Container(
              width: 16 * fontSizeFactor,
              height: 16 * fontSizeFactor,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors[index],
                boxShadow: [
                  BoxShadow(
                    color: colors[index].withOpacity(0.5),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              titles[index],
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 14 * fontSizeFactor),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildDetailsGrid(double aspectRatio, double fontSizeFactor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: values.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: aspectRatio,
        ),
        itemBuilder: (context, index) {
          return ScaleTransition(
            scale: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: _controller,
              curve: Interval(0.5, 1.0, curve: Curves.easeOut),
            )),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${values[index]}',
                      style: TextStyle(
                          fontSize: 22 * fontSizeFactor,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      titles[index],
                      style: TextStyle(
                          fontSize: 16 * fontSizeFactor, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
