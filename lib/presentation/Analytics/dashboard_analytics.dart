import 'package:camp_organizer/bloc/Status/status_bloc.dart';
import 'package:camp_organizer/bloc/Status/status_event.dart';
import 'package:camp_organizer/bloc/Status/status_state.dart';
import 'package:camp_organizer/presentation/Event/event_details.dart';
import 'package:camp_organizer/presentation/notification/notification.dart';
import 'package:camp_organizer/utils/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:bloc/bloc.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
class AnimatedRotatingPieChartWithGrid extends StatefulWidget {
  const AnimatedRotatingPieChartWithGrid({Key? key}) : super(key: key);

  @override
  State<AnimatedRotatingPieChartWithGrid> createState() =>
      _AnimatedRotatingPieChartWithGridState();
}

class _AnimatedRotatingPieChartWithGridState
    extends State<AnimatedRotatingPieChartWithGrid>
    with SingleTickerProviderStateMixin {
  int touchedIndex = -1;
  late AnimationController _controller;
  double rotationAngle = 0;
  late StatusBloc _StatusBloc;
  final List<double> valuess = [];

  List<double> get values {
    return [
      initiatedCount.toDouble(),
      approvedCount.toDouble(),
      waitingQueueCount.toDouble(),
      rejectedCount.toDouble(),


    ];
  }

  final List<Color> colors = [
    Colors.greenAccent,
    Colors.blueAccent,
    Colors.purpleAccent,
    Colors.orangeAccent,

   // Colors.redAccent,


  ];
  final List<String> titles = [
   // 'Total Camp Target',
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
    // Fetch data and initialize counts
    _StatusBloc.stream.listen((state) {
      if (state is StatusLoaded) {
        final employees = state.employees;

        // Initialize the counts based on the data
        setState(() {
          approvedCount = employees
              .where((employee) => employee["campStatus"] == "Approved")
              .length;
          rejectedCount = employees
              .where((employee) => employee["campStatus"] == "Rejected")
              .length;
          waitingQueueCount = employees
              .where((employee) => employee["campStatus"] == "Waiting")
              .length;
          initiatedCount = employees.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _StatusBloc.close();
    super.dispose();
  }

  int approvedCount = 0;
  int rejectedCount = 0;
  int waitingQueueCount = 0;
  int initiatedCount = 0;

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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: BlocBuilder<StatusBloc, StatusState>(
                      builder: (context, state) {
                        return AnimatedSwitcher(
                          duration: Duration(milliseconds: 500),
                          switchInCurve: Curves.easeIn,
                          switchOutCurve: Curves.easeOut,
                          child: () {
                            if (state is StatusLoading) {
                              return Center(
                                key: ValueKey('loading'),
                                child: CircularProgressIndicator(color: Colors.blue,),
                              );
                            } else if (state is StatusLoaded) {
                              final employees = state.employees;

                              // Calculate the approved count once
                              approvedCount = employees
                                  .where((employee) => employee["campStatus"] == "Approved")
                                  .length;
                              rejectedCount = employees
                                  .where((employee) => employee["campStatus"] == "Rejected")
                                  .length;
                              waitingQueueCount = employees
                                  .where((employee) => employee["campStatus"] == "Waiting")
                                  .length;

                              return Column(
                                key: ValueKey('loaded'),
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Approved Card
                                      Expanded(
                                        child: _buildStatusCard(
                                          count: approvedCount,
                                          label: 'Approved',
                                          icon: Icons.check_circle,
                                          gradient: LinearGradient(
                                            colors: [Colors.blueAccent, Colors.lightBlue],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                        ),
                                      ),
                                      // Rejected Card
                                      Expanded(
                                        child: _buildStatusCard(
                                          count: rejectedCount,
                                          label: 'Rejected',
                                          icon: Icons.cancel,
                                          gradient: LinearGradient(
                                            colors: [Colors.redAccent, Colors.orangeAccent],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Waiting Queue Card
                                      Expanded(
                                        child: _buildStatusCard(
                                          count: waitingQueueCount,
                                          label: 'Waiting Queue',
                                          icon: Icons.hourglass_top,
                                          gradient: LinearGradient(
                                            colors: [Colors.purpleAccent, Colors.deepPurple],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                        ),
                                      ),
                                      // Initiated Card
                                      Expanded(
                                        child: _buildStatusCard(
                                          count: employees.length,
                                          label: 'Initiated',
                                          icon: Icons.play_circle_fill,
                                          gradient: LinearGradient(
                                            colors: [Colors.tealAccent, Colors.teal],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            } else if (state is StatusError) {
                              return Center(
                                key: ValueKey('error'),
                                child: Text('Error: ${state.errorMessage}'),
                              );
                            }

                            return Center(
                              key: ValueKey('empty'),
                              child: Text("No data available"),
                            );
                          }(),
                        );
                      },
                    ),
                  ),


                  //  _buildDetailsGrid(gridAspectRatio, fontSizeFactor),
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Upcoming Camps",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 25,
                          color: Colors.black54),
                    ),
                  ),
                  BlocBuilder<StatusBloc, StatusState>(
                    builder: (context, state) {
                      if (state is StatusLoading) {
                        return Center(
                          child: AnimatedTextKit(
                            animatedTexts: [
                              TypewriterAnimatedText(
                                'Loading...',
                                textStyle: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                                speed: Duration(milliseconds: 150), // Adjust speed here
                              ),
                            ],
                            totalRepeatCount: 1, // Set to `1` for single loop, or `0` for infinite
                            pause: Duration(milliseconds: 500), // Pause between loops
                            displayFullTextOnTap: true,
                          ),
                        );
                      } else if (state is StatusLoaded) {
                        // Filter employees with "Approved" campStatus
                        final approvedEmployees = state.employees
                            .where((employee) => employee['campStatus'] == "Approved")
                            .toList();

                        if (approvedEmployees.isEmpty) {
                          // Display "No camp found" when no employees meet the criteria
                          return Center(
                            child: Text(
                              "No camp found",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        }

                        return Padding(
                          padding: EdgeInsets.all(16.0),
                          child: SizedBox(
                            height: constraints.maxHeight * 0.6,
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: approvedEmployees.length,
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

                                return FadeTransition(
                                  opacity: animation,
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: Offset(0, 0.2),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: GestureDetector(
                                      onTap: () async {
                                        print('Employee: ${approvedEmployees[index]}');
                                        print('Employee Doc ID: ${state.employeeDocId[index]}');
                                        print('Camp Doc ID: ${state.campDocId[index]}');

                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EventDetailsPage(
                                              employee: approvedEmployees[index],
                                              employeedocId: state.employeeDocId[index],
                                              campId: state.campDocId[index],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 20),
                                        child: Container(
                                          height: MediaQuery.of(context).size.height * 0.25,
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
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                          approvedEmployees[index]['campDate'],
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
                                                          approvedEmployees[index]['campTime'],
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
                                                ..._buildInfoText(screenWidth, approvedEmployees[index]['campName']),
                                                ..._buildInfoText(screenWidth, approvedEmployees[index]['address']),
                                                ..._buildInfoText(screenWidth, approvedEmployees[index]['name']),
                                                ..._buildInfoText(screenWidth, approvedEmployees[index]['phoneNumber1']),
                                              ],
                                            ),
                                          ),
                                        ),
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
                        child: Text(
                          "No data available",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
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
  Widget _buildStatusCard({
    required int count,
    required String label,
    required IconData icon,
    required Gradient gradient,
  }) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: gradient,
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.white,
            ),
            const SizedBox(height: 12),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ],
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
        title: '${values[i].toInt()}',
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
      child: BlocBuilder<StatusBloc, StatusState>(
        builder: (context, state) {
          if (state is StatusLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is StatusLoaded) {
            final employees = state.employees;

            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 5,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: aspectRatio,
              ),
              itemBuilder: (context, index) {
                int approvedCount = employees
                    .where((employee) => employee["campStatus"] == "Approved")
                    .length;
                return ScaleTransition(
                  scale: Tween<double>(begin: 0.0, end: 1.0)
                      .animate(CurvedAnimation(
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
                            approvedCount.toString(),
                            style: TextStyle(
                                fontSize: 22 * fontSizeFactor,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            titles[index],
                            style: TextStyle(
                                fontSize: 16 * fontSizeFactor,
                                color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
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
    );
  }
}
