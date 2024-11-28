import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/services.dart';

import '../../utils/app_colors.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class CommutativeReportsEventDetails extends StatefulWidget {
  final Map<String, dynamic> employee;
  // final String? employeedocId;
  final String? campId;
  const CommutativeReportsEventDetails({
    Key? key,
    required this.employee,
    // this.employeedocId,
    this.campId,
  }) : super(key: key);

  @override
  _CommutativeReportsEventDetails createState() =>
      _CommutativeReportsEventDetails();
}

class _CommutativeReportsEventDetails
    extends State<CommutativeReportsEventDetails>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _buttonScaleAnimation;
  late Animation<double> _buttonFadeAnimation;
  String? employeeName;
  @override
  void initState() {
    super.initState();
    print("camp doc id: ${widget.campId}");
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
            begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _buttonScaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _buttonFadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    // Start the animation when the page loads
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
    fetchEmployeeName();
  }

  Future<void> fetchEmployeeName() async {
    try {
      final employeeDocId = widget.employee['EmployeeDocId'];
      if (employeeDocId != null) {
        final employeeDoc = await FirebaseFirestore.instance
            .collection('employees')
            .doc(employeeDocId)
            .get();

        if (employeeDoc.exists) {
          final employeeData = employeeDoc.data();
          final employeeFirstName = employeeData?['firstName'] ?? '';
          final employeeLastName = employeeData?['lastName'] ?? '';

          setState(() {
            employeeName =
                '${employeeFirstName.trim()} ${employeeLastName.trim()}'.trim();
          });
        } else {
          print("No such employee document exists.");
        }
      } else {
        print("EmployeeDocId is null.");
      }
    } catch (e) {
      print("Error fetching employee name: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Camp Details',
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      spreadRadius: 2,
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildIconRow(
                          icon: Icons.date_range,
                          text: widget.employee['campDate'],
                          color: Colors.orange,
                          screenWidth: screenWidth,
                        ),
                        _buildIconRow(
                          icon: Icons.watch_later,
                          text: widget.employee['campTime'],
                          color: Colors.orange,
                          screenWidth: screenWidth,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ..._buildDetailRows(screenWidth),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildAnimatedButton(
              label: "Save as Pdf",
              icon: Icons.save,
              color: AppColors.accentBlue,
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
                    final timestamp = DateTime.now().millisecondsSinceEpoch;
                    final path =
                        "${directory.path}/${widget.employee['campName']}_$timestamp.pdf";
                    final file = File(path);
                    await file.writeAsBytes(await pdf.save());

                    print("PDF saved at $path");

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Center(
                          child: Text("PDF saved at $path"),
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    throw Exception("Downloads folder not found.");
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Center(
                        child: Text("Failed to save PDF "),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              screenWidth: screenWidth,
              screenHeight: screenHeight,
            ),
          ],
        ),
      ),
    );
  }

  Row _buildIconRow(
      {required IconData icon,
      required String text,
      required Color color,
      required double screenWidth}) {
    return Row(
      children: [
        Icon(
          icon,
          size: screenWidth * 0.07,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black54,
            fontSize: screenWidth * 0.05,
          ),
        ),
      ],
    );
  }

  Future<List<pw.Widget>> _generatePdfRows() async {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final imageBytes = await rootBundle.load('assets/logo3.png');
    final logo = pw.MemoryImage(imageBytes.buffer.asUint8List());
    return [
      pw.Container(
        padding: pw.EdgeInsets.zero,
        height: screenHeight / 8,
        width: screenWidth,
        decoration: pw.BoxDecoration(
          image: pw.DecorationImage(
            image: logo,
          ),
        ),
      ),
      pw.Container(
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Text(
              "Individual Report",
              style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold, fontSize: screenHeight / 50),
            ),
          ],
        ),
      ),
      pw.SizedBox(height: 15),
      pw.Container(
          child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          _buildPdfRow("Camp Date : ", widget.employee['campDate'] ?? "N/A"),
          _buildPdfRow("Camp Time : ", widget.employee['campTime'] ?? "N/A"),
        ],
      )),
      pw.SizedBox(height: 10),
      _buildPdfRow("Camp Name : ", employeeName ?? "N/A"),
      pw.SizedBox(height: 5),
      _buildPdfRow("Organization : ", widget.employee['organization'] ?? "N/A"),
      pw.SizedBox(height: 5),
      _buildPdfRow("Address : ", widget.employee['address'] ?? "N/A"),
      pw.SizedBox(height: 5),
      pw.Container(
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            _buildPdfRow("City : ", widget.employee['city'] ?? "N/A"),
            _buildPdfRow("State : ", widget.employee['state'] ?? "N/A"),
            _buildPdfRow("Pincode : ", widget.employee['pincode'] ?? "N/A"),
          ],
        ),
      ),
      pw.SizedBox(height: 15),
      pw.Text("Concern Person 1 Details : ",
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      pw.SizedBox(height: 10),
      pw.Container(
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            _buildPdfRow("Name : ", widget.employee['name'] ?? "N/A"),
            _buildPdfRow("Position : ", widget.employee['position'] ?? "N/A"),
          ],
        ),
      ),
      pw.SizedBox(height: 10),
      pw.Container(
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            _buildPdfRow(
                "Phone Number 1 : ", widget.employee['phoneNumber1'] ?? "N/A"),
            _buildPdfRow("Phone Number 2 : ",
                widget.employee['phoneNumber1_2'] ?? "N/A"),
          ],
        ),
      ),
      pw.SizedBox(height: 15),
      pw.Text("Concern Person 2 Details : ",
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      pw.SizedBox(height: 10),
      pw.Container(
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            _buildPdfRow("Name : ", widget.employee['name2'] ?? "N/A"),
            _buildPdfRow("Position : ", widget.employee['position2'] ?? "N/A"),
          ],
        ),
      ),
      pw.SizedBox(height: 10),
      pw.Container(
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            _buildPdfRow(
                "Phone Number 1 : ", widget.employee['phoneNumber2'] ?? "N/A"),
            _buildPdfRow("Phone Number 2 : ",
                widget.employee['phoneNumber2_2'] ?? "N/A"),
          ],
        ),
      ),
      pw.SizedBox(height: 15),
      pw.Text("Event Planning : ",
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      pw.SizedBox(height: 10),
      _buildPdfRow(
          "Camp Plan Type : ", widget.employee['campPlanType'] ?? "N/A"),
      pw.SizedBox(height: 5),
      pw.Container(
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            _buildPdfRow(
                "Road Access : ", widget.employee['roadAccess'] ?? "N/A"),
            _buildPdfRow("Total Square Feet : ",
                widget.employee['totalSquareFeet'] ?? "N/A"),
            _buildPdfRow("Water Availability : ",
                widget.employee['waterAvailability'] ?? "N/A"),
          ],
        ),
      ),
      pw.SizedBox(height: 5),
      _buildPdfRow("No Of Patients Expected : ",
          widget.employee['noOfPatientExpected'] ?? "N/A"),
      pw.SizedBox(height: 5),
      _buildPdfRow(
          "Last Camp Done : ", widget.employee['lastCampDone'] ?? "N/A"),
      pw.SizedBox(height: 10),
      pw.Container(
        child: pw.Column(
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                _buildPdfRow(
                    "Team Doctor : ", widget.employee['doctor'] ?? "N/A"),
                _buildPdfRow("AR : ", widget.employee['ar'] ?? "N/A"),
              ],
            ),
            pw.SizedBox(height: 5),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                _buildPdfRow("InCharge : ",
                    widget.employee['Inward_inChargeName'] ?? "N/A"),
                _buildPdfRow("VnReg : ", widget.employee['vnReg'] ?? "N/A"),
              ],
            ),
            pw.SizedBox(height: 5),
            _buildPdfRow("Regnter : ", widget.employee['regnter'] ?? "N/A"),
            pw.SizedBox(height: 5),
            _buildPdfRow(
                "Camp Organizer : ", widget.employee['campOrganizer'] ?? "N/A"),
          ],
        ),
      ),
      pw.SizedBox(height: 15),
      pw.Container(
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
          children: [
            pw.Text("Bejan Singh Eye Hospital Private Limited"),
            pw.SizedBox(height: 7.5),
            pw.Text(
                "2/313C - M.S Road, Vettoornimadam, Nagercoil, Kanyakumari District, Tamilnadu, India"),
            pw.SizedBox(height: 7.5),
            pw.Text("Info@bseh.org"),
            pw.SizedBox(height: 7.5),
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

  List<Widget> _buildDetailRows(double screenWidth) {
    return [
      _buildDetailRow('Camp Name', widget.employee['campName'], screenWidth),
      _buildDetailRow(
          'Organization', widget.employee['organization'], screenWidth),
      _buildDetailRow('Address', widget.employee['address'], screenWidth),
      _buildDetailRow('City', widget.employee['city'], screenWidth),
      _buildDetailRow('State', widget.employee['state'], screenWidth),
      _buildDetailRow('Pincode', widget.employee['pincode'], screenWidth),
      Text(
        "Concern Person1 Details :",
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black,
          fontSize: screenWidth * 0.05,
        ),
      ),
      _buildDetailRow('Name', widget.employee['name'], screenWidth),
      _buildDetailRow('Position', widget.employee['position'], screenWidth),
      _buildDetailRow(
          'Phone Number 1', widget.employee['phoneNumber1'], screenWidth),
      _buildDetailRow(
          'Phone Number 2', widget.employee['phoneNumber1_2'], screenWidth),
      Text(
        "Concern Person2 Details :",
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black,
          fontSize: screenWidth * 0.05,
        ),
      ),
      _buildDetailRow('Name', widget.employee['name2'], screenWidth),
      _buildDetailRow('Position', widget.employee['position2'], screenWidth),
      _buildDetailRow(
          'Phone Number 1', widget.employee['phoneNumber2'], screenWidth),
      _buildDetailRow(
          'Phone Number 2', widget.employee['phoneNumber2_2'], screenWidth),
      _buildDetailRow(
          'Camp Plan Type', widget.employee['campPlanType'], screenWidth),
      _buildDetailRow(
          'Road Access', widget.employee['roadAccess'], screenWidth),
      _buildDetailRow(
          'Total Square Feet', widget.employee['totalSquareFeet'], screenWidth),
      _buildDetailRow('Water Availability',
          widget.employee['waterAvailability'], screenWidth),
      _buildDetailRow('No Of Patients Expected',
          widget.employee['noOfPatientExpected'], screenWidth),
      _buildDetailRow(
          'Last Camp Done', widget.employee['lastCampDone'], screenWidth),
    ];
  }

  Widget _buildDetailRow(String title, String data, double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black54,
            fontSize: screenWidth * 0.04,
          ),
        ),
        SizedBox(
          width: screenWidth / 10,
        ),
        Flexible(
          child: Text(
            data,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black54,
              fontSize: screenWidth * 0.05,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required double screenWidth,
    required double screenHeight,
  }) {
    return ScaleTransition(
      scale: _buttonScaleAnimation,
      child: FadeTransition(
        opacity: _buttonFadeAnimation,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(
            icon,
            color: Colors.white,
            size: screenWidth * 0.06,
          ),
          label: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.05,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.015, horizontal: screenWidth * 0.08),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
