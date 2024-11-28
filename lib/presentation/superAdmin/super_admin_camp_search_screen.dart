import 'package:camp_organizer/presentation/Analytics/app_resources.dart';
import 'package:camp_organizer/presentation/Event/camp_search_event_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camp_organizer/bloc/approval/adminapproval_bloc.dart';
import 'package:camp_organizer/bloc/approval/adminapproval_state.dart';
import 'package:camp_organizer/bloc/approval/adminapproval_event.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class SuperAdminCampSearchScreen extends StatefulWidget {
  @override
  State<SuperAdminCampSearchScreen> createState() =>
      _SuperAdminCampSearchScreenState();
}

class _SuperAdminCampSearchScreenState extends State<SuperAdminCampSearchScreen>
    with SingleTickerProviderStateMixin {
  late AdminApprovalBloc _AdminApprovalBloc;
  late TextEditingController _searchController;

  List<Map<String, dynamic>> _filteredEmployees = [];
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _AdminApprovalBloc = AdminApprovalBloc()..add(FetchDataEvents());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _AdminApprovalBloc.close();
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
      if (_AdminApprovalBloc.state is AdminApprovalLoaded) {
        _filterEmployees(
            (_AdminApprovalBloc.state as AdminApprovalLoaded).allCamps);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => _AdminApprovalBloc,
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
              if (_AdminApprovalBloc.state is AdminApprovalLoaded) {
                _filterEmployees(
                    (_AdminApprovalBloc.state as AdminApprovalLoaded).allCamps);
              }
            },
            style: const TextStyle(color: Colors.white),
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
                if (_AdminApprovalBloc.state is AdminApprovalLoaded) {
                  _filterEmployees(
                      (_AdminApprovalBloc.state as AdminApprovalLoaded)
                          .allCamps);
                }
              },
            ),
          ],
          // leading: IconButton(
          //   icon: const Icon(
          //     CupertinoIcons.back,
          //     color: Colors.white,
          //   ),
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          // ),
        ),
        body: BlocBuilder<AdminApprovalBloc, AdminApprovalState>(
          builder: (context, state) {
            if (state is AdminApprovalLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AdminApprovalLoaded) {
              if (_searchQuery.isEmpty) {
                _filteredEmployees = state.allCamps;
              }
              if (_filteredEmployees.isEmpty) {
                return Center(
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
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<AdminApprovalBloc>().add(FetchDataEvents());
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _filteredEmployees.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CampSearchEventDetailsPage(
                              employee: _filteredEmployees[index],
                              // employeedocId: state.employeeDocId[1],
                              campId: state.campDocIds[index],
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            height: screenHeight / 3.6,
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
                                            _filteredEmployees[index]
                                                ['campTime'],
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
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: screenWidth / 10,
                                        right: screenWidth / 10),
                                    width: double.maxFinite,
                                    child: ElevatedButton.icon(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () async {
                                        bool? confirmDelete = await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text('Delete Camp'),
                                              content: const Text(
                                                  'Are you sure you want to delete this camp?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, false),
                                                  child: Text('Cancel',
                                                      style: TextStyle(
                                                          color: Colors.blue)),
                                                ),
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, true),
                                                  child: Text('Delete',
                                                      style: TextStyle(
                                                          color: Colors.blue)),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                        if (confirmDelete == true) {
                                          try {
                                            final employeeId =
                                                _filteredEmployees[index]
                                                    ['employeeDocId'];
                                            final campDocId =
                                                _filteredEmployees[index]
                                                    ['documentId'];

                                            context
                                                .read<AdminApprovalBloc>()
                                                .add(DeleteCampEvent(
                                                  employeeId: employeeId,
                                                  campDocId: campDocId,
                                                ));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Center(
                                                  child: Text(
                                                      "Camp Deleted Successfully"),
                                                ),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Center(
                                                  child: Text(
                                                      "Failed to delete the camp"),
                                                ),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white),
                                      label: const Text("Delete"),
                                    ),
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
            } else if (state is AdminApprovalError) {
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
          fontSize: screenWidth * 0.05,
        ),
      ),
    ];
  }
}
