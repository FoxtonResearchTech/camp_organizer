import 'package:camp_organizer/presentation/profile/commutative_reports_event_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../bloc/Status/status_bloc.dart';
import '../../bloc/Status/status_state.dart';
import 'package:camp_organizer/bloc/Status/status_event.dart';

import '../Event/camp_search_event_details.dart';

class CommutativeReportsSearchScreen extends StatefulWidget {
  @override
  State<CommutativeReportsSearchScreen> createState() =>
      _CommutativeReportsSearchScreen();
}

class _CommutativeReportsSearchScreen
    extends State<CommutativeReportsSearchScreen> {
  late StatusBloc _statusBloc;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;

  List<Map<String, dynamic>> _filteredEmployees = [];
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _startDateController = TextEditingController();
    _endDateController = TextEditingController();
    _statusBloc = StatusBloc()..add(FetchDataEvent());
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _statusBloc.close();
    super.dispose();
  }

  void _filterEmployees(List<Map<String, dynamic>> employees) {
    setState(() {
      if (_startDate == null || _endDate == null) {
        _filteredEmployees = employees;
      } else {
        _filteredEmployees = employees.where((employee) {
          DateTime campDate =
              DateFormat('dd-MM-yyyy').parse(employee['campDate']);
          return campDate.isAfter(_startDate!.subtract(Duration(days: 1))) &&
              campDate.isBefore(_endDate!.add(Duration(days: 1)));
        }).toList();
      }
    });
  }

  Future<void> _selectDateRange(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(picked);
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          _startDateController.text = formattedDate;
        } else {
          _endDate = picked;
          _endDateController.text = formattedDate;
        }
      });

      if (_statusBloc.state is StatusLoaded) {
        _filterEmployees((_statusBloc.state as StatusLoaded).employees);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => _statusBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Commutative Reports",
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              CupertinoIcons.back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
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
                onPressed: () {},
                icon: const Icon(
                  Icons.file_download_outlined,
                  color: Colors.white,
                ))
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _startDateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Start Date",
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => _selectDateRange(context, true),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _endDateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "End Date",
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => _selectDateRange(context, false),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<StatusBloc, StatusState>(
                builder: (context, state) {
                  if (state is StatusLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is StatusLoaded) {
                    // Use a post-frame callback to update filtered data after the build.
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_startDate != null || _endDate != null) {
                        _filterEmployees(state.employees);
                      } else if (_filteredEmployees.isEmpty) {
                        setState(() {
                          _filteredEmployees = state.employees;
                        });
                      }
                    });

                    return _buildEmployeeList(state, screenWidth, screenHeight);
                  } else if (state is StatusError) {
                    return const Center(
                      child: Text('Failed to load camps. Please try again.'),
                    );
                  }
                  return const Center(child: Text('No data available.'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeList(
      StatusLoaded state, double screenWidth, double screenHeight) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<StatusBloc>().add(FetchDataEvent());
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _filteredEmployees.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommutativeReportsEventDetails(
                    employee: _filteredEmployees[index],
                    employeedocId: state.employeeDocId[index],
                    campId: state.campDocId[index],
                  ),
                ),
              );
            },
            child: _buildEmployeeCard(index, screenWidth, screenHeight),
          );
        },
      ),
    );
  }

  Widget _buildEmployeeCard(
      int index, double screenWidth, double screenHeight) {
    return Column(
      children: [
        Container(
          height: screenHeight / 5,
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
                          _filteredEmployees[index]['campDate'],
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
                          _filteredEmployees[index]['campTime'],
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
                ..._buildInfoText(
                  screenWidth,
                  _filteredEmployees[index]['campName'],
                ),
                ..._buildInfoText(
                  screenWidth,
                  _filteredEmployees[index]['address'],
                ),
                ..._buildInfoText(
                  screenWidth,
                  _filteredEmployees[index]['name'],
                ),
                ..._buildInfoText(
                  screenWidth,
                  _filteredEmployees[index]['phoneNumber1'],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
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
          fontSize: screenWidth * 0.05,
        ),
      ),
    ];
  }
}
