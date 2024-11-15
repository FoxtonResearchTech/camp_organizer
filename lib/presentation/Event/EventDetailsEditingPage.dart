import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventDetailsEditingPage extends StatefulWidget {
  final Map<String, dynamic> employee;
  final DocumentReference docRef;
  String? campId;
  EventDetailsEditingPage(
      {required this.employee, required this.docRef, this.campId});

  @override
  _EventDetailsEditingPageState createState() =>
      _EventDetailsEditingPageState();
}

class _EventDetailsEditingPageState extends State<EventDetailsEditingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isEditing = true;
  late Map<String, dynamic> _editableEmployee;

  @override
  void initState() {
    super.initState();
    _editableEmployee = Map<String, dynamic>.from(widget.employee);
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: Offset(0, 0.3), end: Offset(0, 0)).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });

    if (!_isEditing) {
      _saveChanges();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

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
        padding: EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildDetailRow(
              'Camp Name', widget.employee['campName'], screenWidth),
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
              color: Colors.black54,
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
              color: Colors.black54,
              fontSize: screenWidth * 0.05,
            ),
          ),
          _buildDetailRow('Name', widget.employee['name2'], screenWidth),
          _buildDetailRow(
              'Position', widget.employee['position2'], screenWidth),
          _buildDetailRow(
              'Phone Number 1', widget.employee['phoneNumber2'], screenWidth),
          _buildDetailRow(
              'Phone Number 2', widget.employee['phoneNumber2_2'], screenWidth),
          _buildDetailRow(
              'Camp Plan Type', widget.employee['campPlanType'], screenWidth),
          _buildDetailRow(
              'Road Access', widget.employee['roadAccess'], screenWidth),
          _buildDetailRow('Total Square Feet',
              widget.employee['totalSquareFeet'], screenWidth),
          _buildDetailRow('Water Availability',
              widget.employee['waterAvailability'], screenWidth),
          _buildDetailRow('No Of Patients Expected',
              widget.employee['noOfPatientExpected'], screenWidth),
          _buildDetailRow(
              'Last Camp Done', widget.employee['lastCampDone'], screenWidth),
        ]),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              icon: Icon(_isEditing ? Icons.save : Icons.edit,
                  color: Colors.white),
              onPressed: _toggleEditMode,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              label: Text(
                _isEditing ? "Save" : "Edit",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value, double screenWidth) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: [
              Text(
                '$label: ',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                  fontSize: screenWidth * 0.05,
                ),
              ),
              _isEditing
                  ? Expanded(
                      child: TextFormField(
                        initialValue: value ?? 'N/A',
                        onChanged: (newValue) {
                          setState(() {
                            _editableEmployee[label] = newValue;
                          });
                        },
                      ),
                    )
                  : Expanded(
                      child: Text(
                        value ?? 'N/A',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveChanges() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final userId = user?.uid;
      final campsSnapshot = await FirebaseFirestore.instance
          .collection('employees')
          .doc(userId)
          .collection('camps')
          .get();

      for (var doc in campsSnapshot.docs) {
        String documentId =
            doc.id; // Document ID of each document in the collection
        print('Document ID: $documentId');
        await FirebaseFirestore.instance
            .collection('employees')
            .doc(userId)
            .collection('camps')
            .doc(widget.campId)
            .update({
          'campName':
              _editableEmployee['Camp Name'] ?? widget.employee['campName'],
          'organization': _editableEmployee['Organization'] ??
              widget.employee['organization'],
          'address': _editableEmployee['Address'] ?? widget.employee['address'],
          'city': _editableEmployee['City'] ?? widget.employee['city'],
          'state': _editableEmployee['State'] ?? widget.employee['state'],
          'pincode': _editableEmployee['Pincode'] ?? widget.employee['pincode'],
          'name': _editableEmployee['Name'] ?? widget.employee['name'],
          'position':
              _editableEmployee['Position'] ?? widget.employee['position'],
          'phoneNumber1': _editableEmployee['Phone Number 1'] ??
              widget.employee['phoneNumber1'],
          'phoneNumber1_2': _editableEmployee['Phone Number 2'] ??
              widget.employee['phoneNumber1_2'],
          'name2': _editableEmployee['Name'] ?? widget.employee['name2'],
          'position2':
              _editableEmployee['Position'] ?? widget.employee['position2'],
          'phoneNumber2': _editableEmployee['Phone Number 1'] ??
              widget.employee['phoneNumber2'],
          'phoneNumber2_2': _editableEmployee['Phone Number 2'] ??
              widget.employee['phoneNumber2_2'],
          'campPlanType': _editableEmployee['Camp Plan Type'] ??
              widget.employee['campPlanType'],
          'roadAccess':
              _editableEmployee['Road Access'] ?? widget.employee['roadAccess'],
          'totalSquareFeet': _editableEmployee['Total Square Feet'] ??
              widget.employee['totalSquareFeet'],
          'waterAvailability': _editableEmployee['Water Availability'] ??
              widget.employee['waterAvailability'],
          'noOfPatientExpected': _editableEmployee['No Of Patients Expected'] ??
              widget.employee['noOfPatientExpected'],
          'lastCampDone': _editableEmployee['Last Camp Done'] ??
              widget.employee['lastCampDone'],
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Changes saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save changes: $e')),
      );
      print(e);
    }
  }
}
