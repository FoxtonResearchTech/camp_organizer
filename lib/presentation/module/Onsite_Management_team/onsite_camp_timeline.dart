import 'package:camp_organizer/bloc/Status/status_event.dart';
import 'package:camp_organizer/widgets/button/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/Status/status_bloc.dart';
import '../../../bloc/approval/adminapproval_bloc.dart';
import '../../../bloc/approval/adminapproval_event.dart';
import '../../../bloc/approval/adminapproval_state.dart';
import '../../notification/notification.dart';

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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => AdminApprovalBloc()..add(FetchDataEvents()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Onsite Camp Timeline',
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
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
                                  size: screenWidth *
                                      0.07, // Responsive icon size
                                  color:
                                  Colors.orange, // Icon color
                                ),
                                SizedBox(width: 20,),
                                Text(
                                  camps[index]['campDate'],
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ],

                            ),


                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                Text(
                                  "Camp Name: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black54,
                                    fontSize: screenWidth *
                                        0.05, // Responsive font size
                                  ),
                                ),
                                Text(
                                  "${camps[index]['campName']}",
                                  style: TextStyle(

                                    color: Colors.black,
                                    fontSize: screenWidth *
                                        0.05, // Responsive font size
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                Text(
                                  "Document ID: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black54,
                                    fontSize: screenWidth *
                                        0.05, // Responsive font size
                                  ),
                                ),
                                Text(
                                  "${camps[index]['documentId']}",
                                  style: TextStyle(

                                    color: Colors.black,
                                    fontSize: screenWidth *
                                        0.05, // Responsive font size
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                Text(
                                  "Camp Time: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black54,
                                    fontSize: screenWidth *
                                        0.05, // Responsive font size
                                  ),
                                ),
                                Text(
                                  "${camps[index]['campTime']}",
                                  style: TextStyle(

                                    color: Colors.black,
                                    fontSize: screenWidth *
                                        0.05, // Responsive font size
                                  ),
                                ),

                              ],
                            ),

                            const SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    _showAddCampTeamDialog(context, camps);
                                  },
                                  child: Text('Add Camp Team',style: TextStyle(color: Colors.green,fontSize: 19),),
                                ),

                                ElevatedButton(
                                  onPressed: () {
                                    print(camp);
                                    //_showAddCampTeamDialog(context, camps);
                                  },
                                  child: const Text('View Team',style: TextStyle(color: Colors.blue,fontSize: 19),),
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
            }),
      ),
    );
  }

  void _showAddCampTeamDialog(BuildContext context, dynamic camp) {
    final TextEditingController teamController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Team to ${camp['campName'].toString()}'),
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
              final teamInfo = teamController.text;
              if (teamInfo.isNotEmpty) {
                _addTeamToCamp(camp, teamInfo);
                Navigator.pop(context);
              }
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
}
