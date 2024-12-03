import 'dart:io';

import 'package:camp_organizer/presentation/profile/commutative_reports_event_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../bloc/Status/status_bloc.dart';
import '../../bloc/Status/status_state.dart';
import 'package:camp_organizer/bloc/Status/status_event.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class CommutativeReportsSearchScreen extends StatefulWidget {
  final String name;
  final String position;
  final String empCode;
  const CommutativeReportsSearchScreen({
    Key? key,
    required this.name,
    required this.position,
    required this.empCode,
  }) : super(key: key);
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
            "Cumulative Reports",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'LeagueSpartan',
            ),
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
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0097b2),
                  Color(0xFF0097b2).withOpacity(1),
                  Color(0xFF0097b2).withOpacity(0.8)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  final pdf = pw.Document();
                  final rows = await _generatePdfRows();

                  // Adding the content to the PDF
                  pdf.addPage(
                    pw.MultiPage(
                      pageFormat: PdfPageFormat.a4,
                      build: (context) {
                        return [...rows];
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
                          "${directory.path}/CommutativeReports_${startingDate.isEmpty ? 0 : startingDate}_to_${endingDate.isEmpty ? 0 : endingDate}_$timestamp.pdf";
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
                                fontWeight: FontWeight.w500,
                                fontFamily: 'LeagueSpartan',
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
              child: BlocBuilder<StatusBloc, StatusState>(
                builder: (context, state) {
                  if (state is StatusLoading) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Color(0xFF0097b2),
                    ));
                  } else if (state is StatusLoaded) {
                    // Use a post-frame callback to update filtered data after the build.
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        if (_startDate != null || _endDate != null) {
                          _filterEmployees(state.employees);
                        } else {
                          _filteredEmployees = state.employees;
                        }
                      });
                    });

                    return RefreshIndicator(
                      color: Color(0xFF0097b2),
                      onRefresh: () async {
                        context.read<StatusBloc>().add(FetchDataEvent());
                      },
                      child:
                          _buildEmployeeList(state, screenWidth, screenHeight),
                    );
                  } else if (state is StatusError) {
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

  int _otherExpenses() {
    return _filteredEmployees.fold<int>(
      0,
      (sum, employee) {
        // Safely handle non-integer values
        var value = employee['otherExpenses'];
        if (value == null) return sum;
        if (value is String) {
          value = int.tryParse(value) ?? 0; // Try to parse string as integer
        }
        return sum + (value as int);
      },
    );
  }

  int _vehicleExpenses() {
    return _filteredEmployees.fold<int>(
      0,
      (sum, employee) {
        var value = employee['vehicleExpenses'];
        if (value == null) return sum; // Handle null
        if (value is String) {
          value = int.tryParse(value) ?? 0;
        }
        return sum + (value as int);
      },
    );
  }

  int _staffSalary() {
    return _filteredEmployees.fold<int>(
      0,
      (sum, employee) {
        var value = employee['staffSalary'];
        if (value == null) return sum; // Handle null
        if (value is String) {
          value = int.tryParse(value) ?? 0;
        }
        return sum + (value as int);
      },
    );
  }

  int _OTx750() {
    return _filteredEmployees.fold<int>(
      0,
      (sum, employee) {
        var value = employee['ot'];
        if (value == null) return sum; // Handle null
        if (value is String) {
          value = int.tryParse(value) ?? 0;
        }
        return sum + (value as int);
      },
    );
  }

  int _CATx2000() {
    return _filteredEmployees.fold<int>(
      0,
      (sum, employee) {
        var value = employee['cat'];
        if (value == null) return sum; // Handle null
        if (value is String) {
          value = int.tryParse(value) ?? 0;
        }
        return sum + (value as int);
      },
    );
  }

  int _gpPayingCase() {
    return _filteredEmployees.fold<int>(
      0,
      (sum, employee) {
        var value = employee['gpPayingCase'];
        if (value == null) return sum; // Handle null
        if (value is String) {
          value = int.tryParse(value) ?? 0;
        }
        return sum + (value as int);
      },
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
      pw.SizedBox(height: 10),
      pw.Container(
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          // crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text("Commutative Report",
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: screenHeight / 40)),
          ],
        ),
      ),
      pw.SizedBox(height: 15),
      pw.Container(
          child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          _buildPdfRow("From : ", startDateString),
          _buildPdfRow("To : ", endDateString),
        ],
      )),
      pw.SizedBox(height: 10),
      pw.Container(
        child: pw.Column(
          children: [
            _buildPdfRow("Name: ", widget.name),
            pw.SizedBox(height: 5),
            _buildPdfRow("Position : ", widget.position),
            pw.SizedBox(height: 5),
            _buildPdfRow("EmpCode: ", widget.empCode),
            pw.SizedBox(height: 5),
          ],
        ),
      ),
      pw.Container(
        child: pw.Column(
          children: [
            pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text("Basic Details ",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ]),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                _buildPdfRow("No Of Camp Initiated: ",
                    _filteredEmployees.length.toString()),
                _buildPdfRow(
                    "No Of Camp Rejected: ", _noOfCampsRejected().toString()),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                _buildPdfRow(
                    "No Of Camp Approved: ", _noOfCampsApproved().toString()),
                _buildPdfRow(
                    "No Of Camp Completed: ", _noOfCampsCompleted().toString()),
              ],
            ),
            pw.SizedBox(height: 10),
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
      pw.Container(
        child: pw.Column(
          children: [
            pw.Column(
              children: [
                pw.Text("Camp Results ",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(
                  height: 5,
                ),
                pw.Column(children: [
                  _buildPdfRow(
                      "No Of OP : ", _noOfPatientsAttended().toString()),
                  pw.SizedBox(height: 15),
                  _buildPdfRow("No Of Cataract Patients : ",
                      _noOfCataractPatients().toString()),
                  pw.SizedBox(height: 15),
                  _buildPdfRow("No Of Patients Selected For Surgery : ",
                      _noOfPatientsSelectedForSurgery().toString()),
                  pw.SizedBox(height: 15),
                  _buildPdfRow("No Of Diabetics Patients : ",
                      _noOfDiabeticsPatients().toString()),
                  pw.SizedBox(height: 15),
                  _buildPdfRow("No Of Glasses Supplied : ",
                      _noOfGlassesSupplied().toString()),
                ])
              ],
            )
          ],
        ),
      ),
      pw.Container(
        child: pw.Column(
          children: [
            pw.Column(children: [
              pw.Text("Camp Expenses ",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
            ]),
            pw.SizedBox(
              height: 5,
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                _buildPdfRow("Other Expense : ", _otherExpenses().toString()),
                _buildPdfRow(
                    "Vehicle Expense : ", _vehicleExpenses().toString()),
              ],
            ),
            pw.SizedBox(height: 15),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                _buildPdfRow("Staff Salary: ", _staffSalary().toString()),
                _buildPdfRow("OTx750 Expense: ", _OTx750().toString()),
              ],
            ),
            pw.SizedBox(height: 15),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                _buildPdfRow("CATx2000 Expense: ", _CATx2000().toString()),
                _buildPdfRow(" GP Paying Case : ", _gpPayingCase().toString()),
              ],
            ),
          ],
        ),
      ),
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
      StatusLoaded state, double screenWidth, double screenHeight) {
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
              ])),
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
                  // employeedocId: state.employeeDocId[index],
                  campId: state.campDocId[index],
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
          height: screenHeight / 4.2,
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
                            fontFamily: 'LeagueSpartan',
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
                            fontFamily: 'LeagueSpartan',
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
          fontFamily: 'LeagueSpartan',
          fontSize: screenWidth * 0.05,
        ),
      ),
    ];
  }
}
