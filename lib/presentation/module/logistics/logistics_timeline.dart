import 'package:camp_organizer/bloc/AddEvent/add_logistics_bloc.dart';
import 'package:camp_organizer/bloc/AddEvent/add_logistics_state.dart';
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

class _LogisticsTimelineState extends State<LogisticsTimeline> with SingleTickerProviderStateMixin {

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
    double screenWidth = MediaQuery.of(context).size.width;


    return BlocListener<AddLogisticsBloc, AddLogisticsState>(
        listener: (context, state) {
          if (state is AddLogisticsLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Adding Logistics...')),
            );
          } else if (state is AddLogisticsSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Logistics added successfully!')),
            );
          } else if (state is AddLogisticsError) {
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
          body: BlocBuilder<AdminApprovalBloc, AdminApprovalState>(
            builder: (context, state) {
              if (state is AdminApprovalLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is AdminApprovalLoaded) {
                final camps = state.allCamps;

                return ListView.builder(
                  itemCount: camps.length,
                  itemBuilder: (context, index) {
                    final camp = camps[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 16.0),
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.date_range,
                                  size: screenWidth * 0.07,
                                  color: Colors.lightBlueAccent,
                                ),
                                const SizedBox(width: 20),
                                Text(
                                  camps[index]['campDate'],
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                const Text(
                                  "Camp Name: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black54,
                                  ),
                                ),
                                Text(
                                  "${camps[index]['campName']}",
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                const Text(
                                  "Document ID: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black54,
                                  ),
                                ),
                                Text(
                                  "${camps[index]['documentId']}",
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                const Text(
                                  "Camp Time: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black54,
                                  ),
                                ),
                                Text(
                                  "${camps[index]['campTime']}",
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      //_showAddCampTeamDialog(
                                      // context, camp['documentId']);
                                      final documentId = camp['documentId'];
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LogisticsOutward(
                                              documentId: documentId,
                                              campData: camp),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Outward',
                                      style: TextStyle(
                                          color: Colors.black87, fontSize: 19),
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.lightBlueAccent), // Set the background color
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),

                                Expanded(
                                  child: ElevatedButton(

                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LogisticsOutwardPage(
                                              campData: camp),
                                        ),
                                      );

                                      print(camp);
                                    },
                                    child: const Text(
                                      'View Details',
                                      style: TextStyle(
                                          color: Colors.black87, fontSize: 19),
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.lightBlueAccent), // Set the background color
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      //_showAddCampTeamDialog(
                                      // context, camp['documentId']);
                                      final documentId = camp['documentId'];
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LogisticsInward(
                                              documentId: documentId,
                                              campData: camp),
                                        ),
                                      );

                                      print(camp);
                                    },
                                    child: const Text(
                                      'Inward',
                                      style: TextStyle(
                                          color: Colors.black87, fontSize: 19),
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.lightBlueAccent), // Set the background color
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),

                                Expanded(
                                  child: ElevatedButton(

                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => InwardDetails(
                                              campData: camp),
                                        ),
                                      );
                                      print(camp);
                                    },
                                    child: const Text(
                                      'View Details',
                                      style: TextStyle(
                                          color: Colors.black87, fontSize: 19),
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.lightBlueAccent), // Set the background color
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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
}
