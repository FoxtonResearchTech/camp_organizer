import 'package:camp_organizer/presentation/Event/camp_search_event_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camp_organizer/bloc/Status/status_bloc.dart';
import 'package:camp_organizer/bloc/Status/status_event.dart';
import 'package:camp_organizer/bloc/Status/status_state.dart';
import 'package:camp_organizer/presentation/Event/event_details.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class CampSearchScreen extends StatefulWidget {
  @override
  State<CampSearchScreen> createState() => _CampSearchScreenState();
}

class _CampSearchScreenState extends State<CampSearchScreen>
    with SingleTickerProviderStateMixin {
  late StatusBloc _statusBloc;
  late TextEditingController _searchController;

  List<Map<String, dynamic>> _filteredEmployees = [];
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _statusBloc = StatusBloc()..add(FetchDataEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _statusBloc.close();
    super.dispose();
  }

  void _filterEmployees(List<Map<String, dynamic>> employees) {
    setState(() {
      if (_searchQuery.isEmpty) {
        _filteredEmployees = employees;
      } else {
        _filteredEmployees = employees
            .where((employee) =>
                employee['campName']
                    .toString()
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ||
                employee['campDate']
                    .toString()
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      // Format the date as dd-MM-yy
      String formattedDate = DateFormat('dd-MM-yyyy').format(picked);

      // Update the search controller and search query
      _searchController.text = formattedDate;
      setState(() {
        _searchQuery = formattedDate;
      });

      // Filter employees based on the formatted date
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
          title: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
              if (_statusBloc.state is StatusLoaded) {
                _filterEmployees((_statusBloc.state as StatusLoaded).employees);
              }
            },
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'LeagueSpartan',
            ),
            decoration: InputDecoration(
              hintText: "Search by camp name or date...",
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
              border: InputBorder.none,
            ),
          ),
          centerTitle: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ Color(0xFF0097b2),  Color(0xFF0097b2).withOpacity(1), Color(0xFF0097b2).withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.calendar_today, color: Colors.white),
              onPressed: () => _selectDate(context),
            ),
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.white),
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = "";
                });
                if (_statusBloc.state is StatusLoaded) {
                  _filterEmployees(
                      (_statusBloc.state as StatusLoaded).employees);
                }
              },
            ),
          ],
          leading: IconButton(
            icon: const Icon(
              CupertinoIcons.back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: BlocBuilder<StatusBloc, StatusState>(
          builder: (context, state) {
            if (state is StatusLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is StatusLoaded) {
              if (_searchQuery.isEmpty) {
                _filteredEmployees = state.employees;
              }
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<StatusBloc>().add(FetchDataEvent());
                },
                child: _filteredEmployees.isEmpty
                    ? SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Center(
                            child: Container(
                          padding: EdgeInsets.only(top: screenHeight / 4),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset(
                                  'assets/no_records.json',
                                  width: screenWidth * 0.6,
                                  height: screenHeight * 0.4,
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  "No matching record found",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'LeagueSpartan',
                                    color: Colors.grey,
                                  ),
                                ),
                              ]),
                        )),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: _filteredEmployees.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CampSearchEventDetailsPage(
                                    employee: _filteredEmployees[index],
                                    // employeedocId: state.employeeDocId[index],
                                    campId: state.campDocId[index],
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Container(
                                  height: screenHeight / 4,
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
                                                  _filteredEmployees[index]
                                                      ['campDate'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black54,
                                                    fontFamily: 'LeagueSpartan',
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
                                                  _filteredEmployees[index]
                                                      ['campTime'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'LeagueSpartan',
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
                                          _filteredEmployees[index]
                                              ['phoneNumber1'],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          );
                        },
                      ),
              );
            } else if (state is StatusError) {
              return const Center(
                child: Text('Failed to load camps. Please try again.'),
              );
            }
            return const Center(child: Text('No data available.'));
          },
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
          fontFamily: 'LeagueSpartan',
          fontSize: screenWidth * 0.05,
        ),
      ),
    ];
  }
}
