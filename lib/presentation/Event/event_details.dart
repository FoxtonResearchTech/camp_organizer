import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class EventDetailsPage extends StatelessWidget {
  final Map<String, dynamic> employee;

  const EventDetailsPage({Key? key, required this.employee}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Screen size parameters
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Details',
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
          ), // iOS back button icon
          onPressed: () {
            Navigator.pop(
                context); // Pop the current page from the navigation stack
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
          child: Container(
            padding: const EdgeInsets.all(16.0),
            height: screenHeight, // Responsive height
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
                          // Responsive icon size
                          color: Colors.orange, // Icon color
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '12-02-2024',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                            fontSize:
                                screenWidth * 0.05, // Responsive font size
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.watch_later,
                          size: screenWidth * 0.07,
                          // Responsive icon size
                          color: Colors.orange, // Icon color
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Morning',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                            fontSize:
                                screenWidth * 0.05, // Responsive font size
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildDetailRow('Camp Name', employee['campName'], screenWidth),
                _buildDetailRow(
                    'Organization', employee['organization'], screenWidth),
                _buildDetailRow('Address', employee['address'], screenWidth),
                _buildDetailRow('City', employee['city'], screenWidth),
                _buildDetailRow('State', employee['state'], screenWidth),
                _buildDetailRow('Pincode', employee['pincode'], screenWidth),
                _buildDetailRow('Concern Person1 Details',
                    employee['Concern Person1 Details'], screenWidth),
                _buildDetailRow('Name', employee['Name'], screenWidth),
                _buildDetailRow('Position', employee['Position'], screenWidth),
                _buildDetailRow(
                    'Phone Number 1', employee['Phone Number 1'], screenWidth),
                _buildDetailRow(
                    'Phone Number 2', employee['Phone Number 2'], screenWidth),
                _buildDetailRow('Concern Person2 Details',
                    employee['Concern Person2 Details'], screenWidth),
                _buildDetailRow('Name', employee['Name'], screenWidth),
                _buildDetailRow('Position', employee['Position'], screenWidth),
                _buildDetailRow(
                    'Phone Number 1', employee['Phone Number 1'], screenWidth),
                _buildDetailRow(
                    'Phone Number 2', employee['Phone Number 2'], screenWidth),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: screenWidth / 3,
              height: screenHeight / 15,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  iconColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  backgroundColor: AppColors.accentBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                label: const Text(
                  " Edit",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(
              width: screenWidth / 3,
              height: screenHeight / 15,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  iconColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  backgroundColor: AppColors.accentBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                label: const Text(
                  " Edit",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black54,
              fontSize: screenWidth * 0.05, // Responsive font size
            ),
          ),
          Text(value ?? 'N/A'),
        ],
      ),
    );
  }
}
