import 'package:camp_organizer/bloc/AddEvent/add_finance_bloc.dart';
import 'package:camp_organizer/presentation/module/Finance_Reports/finance_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

class _FinanceTimelineState extends State<FinanceTimeline> with SingleTickerProviderStateMixin {

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

    return BlocListener<AddFinanceBloc, AddFinanceState>(
        listener: (context, state) {
          if (state is AddFinanceLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Loading Finance Details...')),
            );
          } else if (state is AddFinanceSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Finance Details Loaded successfully!')),
            );
          } else if (state is AddFinanceError) {
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
                'Camp Finance Timeline',
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
                                            builder: (context) => FinanceAddExpense(
                                                documentId: documentId,
                                                campData: camp),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'Add Finance',
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
                                            builder: (context) => FinanceDetails(
                                                campData: camp),
                                          ),
                                        );
                                        print(camp);
                                      },
                                      child: const Text(
                                        'View Finance',
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

}
