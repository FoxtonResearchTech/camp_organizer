import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/animation.dart';

import '../../utils/app_colors.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class CampSearchEventDetailsPage extends StatefulWidget {
  final Map<String, dynamic> employee;
  // final String? employeedocId;
  final String? campId;
  const CampSearchEventDetailsPage({
    Key? key,
    required this.employee,
    // this.employeedocId,
    this.campId,
  }) : super(key: key);

  @override
  _CampSearchEventDetailsPage createState() => _CampSearchEventDetailsPage();
}

class _CampSearchEventDetailsPage extends State<CampSearchEventDetailsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _buttonScaleAnimation;
  late Animation<double> _buttonFadeAnimation;

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

                // Adding the content to the PDF
                pdf.addPage(
                  pw.Page(
                    pageFormat: PdfPageFormat.a4,
                    build: (context) {
                      return pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text("Camp Details",
                              style: pw.TextStyle(
                                  fontSize: 35,
                                  fontWeight: pw.FontWeight.bold)),
                          pw.SizedBox(height: 20),
                          ..._generatePdfRows(),
                        ],
                      );
                    },
                  ),
                );

                // Save the file to the Downloads folder
                try {
                  // Get the Downloads folder directory
                  final directory = Directory('/storage/emulated/0/Download');
                  if (await directory.exists()) {
                    final path =
                        "${directory.path}/${widget.employee['campName']}.pdf";
                    final file = File(path);
                    await file.writeAsBytes(await pdf.save());

                    print("PDF saved at $path");

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("PDF saved at $path")),
                    );
                  } else {
                    throw Exception("Downloads folder not found.");
                  }
                } catch (e) {
                  // Handle errors
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to save PDF: $e")),
                  );
                }
              },
              screenWidth: screenWidth,
              screenHeight: screenHeight,
            )
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

  List<pw.Widget> _generatePdfRows() {
    return [
      pw.Container(
          child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          _buildPdfRow("Camp Date : ", widget.employee['campDate'] ?? "N/A"),
          _buildPdfRow("Camp Time : ", widget.employee['campTime'] ?? "N/A"),
        ],
      )),
      pw.SizedBox(height: 20),
      _buildPdfRow("Camp Name : ", widget.employee['campName'] ?? "N/A"),
      pw.SizedBox(height: 10),
      _buildPdfRow("Organization : ", widget.employee['organization'] ?? "N/A"),
      pw.SizedBox(height: 10),
      _buildPdfRow("Address : ", widget.employee['address'] ?? "N/A"),
      pw.SizedBox(height: 10),
      _buildPdfRow("City : ", widget.employee['city'] ?? "N/A"),
      pw.SizedBox(height: 10),
      _buildPdfRow("State : ", widget.employee['state'] ?? "N/A"),
      pw.SizedBox(height: 10),
      _buildPdfRow("Pincode : ", widget.employee['pincode'] ?? "N/A"),
      pw.SizedBox(height: 15),
      pw.Text("Concern Person 1 Details :",
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      pw.SizedBox(height: 15),
      _buildPdfRow("Name : ", widget.employee['name'] ?? "N/A"),
      pw.SizedBox(height: 10),
      _buildPdfRow("Position : ", widget.employee['position'] ?? "N/A"),
      pw.SizedBox(height: 10),
      _buildPdfRow(
          "Phone Number 1 : ", widget.employee['phoneNumber1'] ?? "N/A"),
      pw.SizedBox(height: 10),
      _buildPdfRow(
          "Phone Number 2 : ", widget.employee['phoneNumber1_2'] ?? "N/A"),
      pw.SizedBox(height: 15),
      pw.Text("Concern Person 2 Details :",
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      pw.SizedBox(height: 15),
      _buildPdfRow("Name : ", widget.employee['name2'] ?? "N/A"),
      pw.SizedBox(height: 10),
      _buildPdfRow("Position : ", widget.employee['position2'] ?? "N/A"),
      pw.SizedBox(height: 10),
      _buildPdfRow(
          "Phone Number 1 : ", widget.employee['phoneNumber2'] ?? "N/A"),
      pw.SizedBox(height: 10),
      _buildPdfRow(
          "Phone Number 2 : ", widget.employee['phoneNumber2_2'] ?? "N/A"),
      pw.SizedBox(height: 15),
      _buildPdfRow(
          "Camp Plan Type : ", widget.employee['campPlanType'] ?? "N/A"),
      pw.SizedBox(height: 10),
      _buildPdfRow("Road Access : ", widget.employee['roadAccess'] ?? "N/A"),
      pw.SizedBox(height: 10),
      _buildPdfRow(
          "Total Square Feet : ", widget.employee['totalSquareFeet'] ?? "N/A"),
      pw.SizedBox(height: 10),
      _buildPdfRow("Water Availability : ",
          widget.employee['waterAvailability'] ?? "N/A"),
      pw.SizedBox(height: 10),
      _buildPdfRow("No Of Patients Expected : ",
          widget.employee['noOfPatientExpected'] ?? "N/A"),
      pw.SizedBox(height: 10),
      _buildPdfRow(
          "Last Camp Done : ", widget.employee['lastCampDone'] ?? "N/A"),
      pw.SizedBox(height: 10),
    ];
  }

  pw.Widget _buildPdfRow(String title, String data) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(title ?? "N/A",
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text(data),
      ],
    );
  }

  List<Widget> _buildDetailRows(double screenWidth) {
    return [
      _buildDetailRow(
          'Camp Name', widget.employee['campName'] ?? "N/A", screenWidth),
      _buildDetailRow('Organization', widget.employee['organization'] ?? "N/A",
          screenWidth),
      _buildDetailRow(
          'Address', widget.employee['address'] ?? "N/A", screenWidth),
      _buildDetailRow('City', widget.employee['city'] ?? "N/A", screenWidth),
      _buildDetailRow('State', widget.employee['state'] ?? "N/A", screenWidth),
      _buildDetailRow(
          'Pincode', widget.employee['pincode'] ?? "N/A", screenWidth),
      Text(
        "Concern Person1 Details :",
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black,
          fontSize: screenWidth * 0.05,
        ),
      ),
      _buildDetailRow('Name', widget.employee['name'] ?? "N/A", screenWidth),
      _buildDetailRow(
          'Position', widget.employee['position'] ?? "N/A", screenWidth),
      _buildDetailRow('Phone Number 1',
          widget.employee['phoneNumber1'] ?? "N/A", screenWidth),
      _buildDetailRow('Phone Number 2',
          widget.employee['phoneNumber1_2'] ?? "N/A", screenWidth),
      Text(
        "Concern Person2 Details :",
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black,
          fontSize: screenWidth * 0.05,
        ),
      ),
      _buildDetailRow('Name', widget.employee['name2'] ?? "N/A", screenWidth),
      _buildDetailRow(
          'Position', widget.employee['position2'] ?? "N/A", screenWidth),
      _buildDetailRow('Phone Number 1',
          widget.employee['phoneNumber2'] ?? "N/A", screenWidth),
      _buildDetailRow('Phone Number 2',
          widget.employee['phoneNumber2_2'] ?? "N/A", screenWidth),
      _buildDetailRow('Camp Plan Type',
          widget.employee['campPlanType'] ?? "N/A", screenWidth),
      _buildDetailRow(
          'Road Access', widget.employee['roadAccess'] ?? "N/A", screenWidth),
      _buildDetailRow('Total Square Feet',
          widget.employee['totalSquareFeet'] ?? "N/A", screenWidth),
      _buildDetailRow('Water Availability',
          widget.employee['waterAvailability'] ?? "N/A", screenWidth),
      _buildDetailRow('No Of Patients Expected',
          widget.employee['noOfPatientExpected'] ?? "N/A", screenWidth),
      _buildDetailRow('Last Camp Done',
          widget.employee['lastCampDone'] ?? "N/A", screenWidth),
    ];
  }

  Widget _buildDetailRow(String title, String data, double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title ?? "N/A",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black54,
            fontSize: screenWidth * 0.04,
          ),
        ),
        Text(
          data ?? "N/A",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black54,
            fontSize: screenWidth * 0.05,
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
