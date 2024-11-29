import 'dart:io';

import 'package:camp_organizer/bloc/approval/adminapproval_bloc.dart';
import 'package:camp_organizer/presentation/profile/commutative_reports_event_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import 'package:camp_organizer/bloc/approval/adminapproval_bloc.dart';
import 'package:camp_organizer/bloc/approval/adminapproval_state.dart';
import 'package:camp_organizer/bloc/approval/adminapproval_event.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class SuperAdminCommutativeReportsSearchScreen extends StatefulWidget {
  final String name;
  final String position;
  final String empCode;
  const SuperAdminCommutativeReportsSearchScreen({
    Key? key,
    required this.name,
    required this.position,
    required this.empCode,
  }) : super(key: key);
  @override
  State<SuperAdminCommutativeReportsSearchScreen> createState() =>
      _SuperCommutativeReportsSearchScreen();
}

class _SuperCommutativeReportsSearchScreen
    extends State<SuperAdminCommutativeReportsSearchScreen> {
  late AdminApprovalBloc _AdminApprovalBloc;
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
    _AdminApprovalBloc = AdminApprovalBloc()..add(FetchDataEvents());
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _AdminApprovalBloc.close();
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
          return campDate
                  .isAfter(_startDate!.subtract(const Duration(days: 1))) &&
              campDate.isBefore(_endDate!.add(const Duration(days: 1)));
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
          title: const Text(
            "Commutative Reports",
            style: TextStyle(
              fontFamily: 'LeagueSpartan',
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
          elevation: 0,
          // leading: IconButton(
          //   icon: const Icon(
          //     CupertinoIcons.back,
          //     color: Colors.white,
          //   ),
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          // ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.lightBlueAccent, Colors.lightBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              CupertinoIcons.back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  final pdf = pw.Document();
                  final rows = await _generatePdfRows();

                  // Adding the content to the PDF
                  pdf.addPage(
                    pw.Page(
                      pageFormat: PdfPageFormat.a4,
                      build: (context) {
                        return pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: rows,
                        );
                      },
                    ),
                  );

                  // Save the file to the Downloads folder
                  try {
                    // Get the Downloads folder directory
                    final directory = Directory('/storage/emulated/0/Download');
                    if (await directory.exists()) {
                      final startingDate = _startDateController.text;
                      final endingDate = _endDateController.text;
                      final timestamp = DateTime.now().millisecondsSinceEpoch;
                      final path =
                          "${directory.path}/SuperAdminCommutativeReports_${startingDate.isEmpty ? 0 : startingDate}_to_${endingDate.isEmpty ? 0 : endingDate}_$timestamp.pdf";
                      final file = File(path);
                      await file.writeAsBytes(await pdf.save());

                      print("PDF saved at $path");

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Center(child: Text("PDF saved at $path")),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      throw Exception("Downloads folder not found.");
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Center(child: Text("Failed to save PDF")),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Start Date Field
                  Flexible(
                    child: GestureDetector(
                      onTap: () => _selectDateRange(context, true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _startDateController.text.isNotEmpty
                                  ? _startDateController.text
                                  : "Start Date",
                              style: TextStyle(
                                color: _startDateController.text.isNotEmpty
                                    ? Colors.black
                                    : Colors.grey[600],
                                fontSize: 16,
                                fontFamily: 'LeagueSpartan',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Icon(Icons.calendar_today,
                                color: Colors.orangeAccent),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // End Date Field
                  Flexible(
                    child: GestureDetector(
                      onTap: () => _selectDateRange(context, false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _endDateController.text.isNotEmpty
                                  ? _endDateController.text
                                  : "End Date",
                              style: TextStyle(
                                color: _endDateController.text.isNotEmpty
                                    ? Colors.black
                                    : Colors.grey[600],
                                fontSize: 16,
                                fontFamily: 'LeagueSpartan',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Icon(Icons.calendar_today,
                                color: Colors.orangeAccent),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<AdminApprovalBloc, AdminApprovalState>(
                builder: (context, state) {
                  if (state is AdminApprovalLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is AdminApprovalLoaded) {
                    // Use a post-frame callback to update filtered data after the build.
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        if (_startDate != null || _endDate != null) {
                          _filterEmployees(state.allCamps);
                        } else {
                          _filteredEmployees = state.allCamps;
                        }
                      });
                    });
                    return RefreshIndicator(
                      onRefresh: () async {
                        context
                            .read<AdminApprovalBloc>()
                            .add(FetchDataEvents());
                      },
                      child:
                          _buildEmployeeList(state, screenWidth, screenHeight),
                    );
                    // return _buildEmployeeList(state, screenWidth, screenHeight);
                  } else if (state is AdminApprovalError) {
                    return const Center(
                      child: Text(
                        'Failed to load camps. Please try again.',
                        style: TextStyle(
                          fontFamily: 'LeagueSpartan',
                        ),
                      ),
                    );
                  }
                  return const Center(
                      child: Text(
                    'No data available.',
                    style: TextStyle(
                      fontFamily: 'LeagueSpartan',
                    ),
                  ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _noOfCampsApproved() {
    return _filteredEmployees
        .where((employee) => employee['campStatus'] == 'Approved')
        .length;
  }

  int _noOfCampsRejected() {
    return _filteredEmployees
        .where((employee) => employee['campStatus'] == 'Rejected')
        .length;
  }

  int _noOfCampsCompleted() {
    return _filteredEmployees
        .where((employee) => employee['campStatus'] == 'Completed')
        .length;
  }

  int _noOfCampsWaiting() {
    return _filteredEmployees
        .where((employee) => employee['campStatus'] == 'Waiting')
        .length;
  }

  int _noOfCataractPatients() {
    return _filteredEmployees.fold<int>(
      0,
      (sum, employee) => sum + ((employee['cataractPatients'] ?? 0) as int),
    );
  }

  int _noOfPatientsSelectedForSurgery() {
    return _filteredEmployees.fold<int>(
      0,
      (sum, employee) =>
          sum + ((employee['patientsSelectedForSurgery'] ?? 0) as int),
    );
  }

  int _noOfPatientsAttended() {
    return _filteredEmployees.fold<int>(
      0,
      (sum, employee) => sum + ((employee['patientsAttended'] ?? 0) as int),
    );
  }

  int _noOfDiabeticsPatients() {
    return _filteredEmployees.fold<int>(
      0,
      (sum, employee) => sum + ((employee['diabeticPatients'] ?? 0) as int),
    );
  }

  int _noOfGlassesSupplied() {
    return _filteredEmployees.fold<int>(
      0,
      (sum, employee) => sum + ((employee['glassesSupplied'] ?? 0) as int),
    );
  }

  Future<List<pw.Widget>> _generatePdfRows() async {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final imageBytes = await rootBundle.load('assets/logo3.png');
    final logo = pw.MemoryImage(imageBytes.buffer.asUint8List());
    final startDateString = _startDate != null
        ? DateFormat('dd-MM-yyyy').format(_startDate!)
        : "Not Selected";
    final endDateString = _endDate != null
        ? DateFormat('dd-MM-yyyy').format(_endDate!)
        : "Not Selected";
    return [
      pw.Container(
        padding: pw.EdgeInsets.only(top: screenHeight * 0.02),
        height: screenHeight / 8,
        width: screenWidth,
        decoration: pw.BoxDecoration(
          image: pw.DecorationImage(
            image: logo,
          ),
        ),
      ),
      pw.SizedBox(height: 20),
      pw.Container(
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          // crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text("Commutative Report",
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: screenHeight / 50)),
          ],
        ),
      ),
      pw.SizedBox(height: 25),
      pw.Container(
          child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          _buildPdfRow("From : ", startDateString),
          _buildPdfRow("To : ", endDateString),
        ],
      )),
      pw.SizedBox(height: 20),
      _buildPdfRow("Name: ", widget.name),
      pw.SizedBox(height: 10),
      pw.Container(
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            _buildPdfRow("Position : ", widget.position),
            _buildPdfRow("EmpCode: ", widget.empCode),
          ],
        ),
      ),
      pw.SizedBox(height: 20),
      pw.Container(
        child: pw.Column(
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                _buildPdfRow("No Of Camp Initiated: ",
                    _filteredEmployees.length.toString()),
                _buildPdfRow(
                    "No Of Camp Rejected: ", _noOfCampsRejected().toString()),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                _buildPdfRow(
                    "No Of Camp Approved: ", _noOfCampsApproved().toString()),
                _buildPdfRow(
                    "No Of Camp Completed: ", _noOfCampsCompleted().toString()),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                _buildPdfRow(
                    "No Of Camp Waiting: ", _noOfCampsWaiting().toString()),
              ],
            ),
          ],
        ),
      ),
      pw.SizedBox(height: 20),
      _buildPdfRow("Camp results ", ""),
      pw.SizedBox(height: 15),
      _buildPdfRow("No Of OP : ", _noOfPatientsAttended().toString()),
      pw.SizedBox(height: 10),
      _buildPdfRow(
          "No Of Cataract Patients : ", _noOfCataractPatients().toString()),
      pw.SizedBox(height: 10),
      _buildPdfRow("No Of Patients Selected For Surgery : ",
          _noOfPatientsSelectedForSurgery().toString()),
      pw.SizedBox(height: 10),
      _buildPdfRow(
          "No Of Diabetics Patients : ", _noOfDiabeticsPatients().toString()),
      pw.SizedBox(height: 10),
      _buildPdfRow(
          "No Of Glasses Supplied : ", _noOfGlassesSupplied().toString()),
      pw.SizedBox(height: 30),
      pw.Container(
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
          children: [
            pw.Text("Bejan Singh Eye Hospital Private Limited"),
            pw.SizedBox(height: 15),
            pw.Text(
                "2/313C - M.S Road, Vettoornimadam, Nagercoil, Kanyakumari District, Tamilnadu, India"),
            pw.SizedBox(height: 15),
            pw.Text("Info@bseh.org"),
            pw.SizedBox(height: 15),
            pw.Text("+91 9488409991 \n,+91 7871957881"),
          ],
        ),
      ),
    ];
  }

  pw.Widget _buildPdfRow(String title, String data) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text(data),
      ],
    );
  }

  Widget _buildEmployeeList(
      AdminApprovalLoaded state, double screenWidth, double screenHeight) {
    if (_filteredEmployees.isEmpty) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          padding: EdgeInsets.only(top: screenHeight / 6),
          child: Center(
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
              ],
            ),
          ),
        ),
      );
    }
    return ListView.builder(
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
                  // employeedocId: state.employeeDocId[1],
                  campId: state.campDocIds[index],
                ),
              ),
            );
          },
          child: _buildEmployeeCard(index, screenWidth, screenHeight),
        );
      },
    );
  }

  Widget _buildEmployeeCard(
      int index, double screenWidth, double screenHeight) {
    return Column(
      children: [
        Container(
          height: screenHeight / 3.75,
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
                            fontFamily: 'LeagueSpartan',
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
                            fontFamily: 'LeagueSpartan',
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
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.only(
                      left: screenWidth / 10, right: screenWidth / 10),
                  width: double.maxFinite,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      bool? confirmDelete = await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              'Delete Camp',
                              style: TextStyle(
                                fontFamily: 'LeagueSpartan',
                              ),
                            ),
                            content: const Text(
                              'Are you sure you want to delete this camp?',
                              style: TextStyle(
                                fontFamily: 'LeagueSpartan',
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text('Cancel',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontFamily: 'LeagueSpartan',
                                    )),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text('Delete',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontFamily: 'LeagueSpartan',
                                    )),
                              ),
                            ],
                          );
                        },
                      );
                      if (confirmDelete == true) {
                        try {
                          final employeeId =
                              _filteredEmployees[index]['employeeDocId'];
                          final campDocId =
                              _filteredEmployees[index]['documentId'];

                          context.read<AdminApprovalBloc>().add(DeleteCampEvent(
                                employeeId: employeeId,
                                campDocId: campDocId,
                              ));
                          setState(() {
                            _filteredEmployees.removeAt(index);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Center(
                                  child: Text("Camp Deleted Successfully")),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Center(
                                  child: Text("Failed to delete the camp")),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white),
                    label: Text(
                      "Delete",
                      style: TextStyle(
                        fontFamily: 'LeagueSpartan',
                      ),
                    ),
                  ),
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
          fontFamily: 'LeagueSpartan',
          fontSize: screenWidth * 0.05,
        ),
      ),
    ];
  }
}
