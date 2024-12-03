// import 'package:camp_organizer/presentation/module/admin/selected_employee_camp_search_screen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// import '../../Event/camp_search_event_details.dart';
//
// class IndividualReports extends StatefulWidget {
//   final String employeeName;
//   final String reportType;
//
//   const IndividualReports({
//     Key? key,
//     required this.employeeName,
//     required this.reportType,
//   }) : super(key: key);
//
//   @override
//   _IndividualReports createState() => _IndividualReports();
// }
//
// class _IndividualReports extends State<IndividualReports> {
//   List<Map<String, dynamic>> camps = [];
//   bool isLoading = true;
//   List<String> campDocIds = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchCamps();
//   }
//
//   Future<void> fetchCamps() async {
//     try {
//       List<String> nameParts = widget.employeeName.split(' ');
//       String firstName = nameParts[0];
//       String? lastName = nameParts.length > 1 ? nameParts[1] : null;
//
//       QuerySnapshot employeeSnapshot;
//
//       if (lastName != null) {
//         // Query for both firstName and lastName
//         employeeSnapshot = await FirebaseFirestore.instance
//             .collection('employees')
//             .where('firstName', isEqualTo: firstName)
//             .where('lastName', isEqualTo: lastName)
//             .get();
//       } else {
//         // Query only for firstName
//         employeeSnapshot = await FirebaseFirestore.instance
//             .collection('employees')
//             .where('firstName', isEqualTo: firstName)
//             .get();
//       }
//
//       if (employeeSnapshot.docs.isNotEmpty) {
//         String employeeId = employeeSnapshot.docs.first.id;
//
//         QuerySnapshot campsSnapshot = await FirebaseFirestore.instance
//             .collection('employees')
//             .doc(employeeId)
//             .collection('camps')
//             .get();
//
//         setState(() {
//           campDocIds = campsSnapshot.docs.map((doc) => doc.id).toList();
//           camps = campsSnapshot.docs
//               .map((doc) => doc.data() as Map<String, dynamic>)
//               .toList();
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//         print("No employee document found for name: ${widget.employeeName}");
//       }
//     } catch (e) {
//       print('Error fetching camps: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(
//             Icons.arrow_back_ios,
//             color: Colors.white,
//           ),
//         ),
//         title: const Text(
//           'Individual Report',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//             fontFamily: 'LeagueSpartan',
//           ),
//         ),
//         centerTitle: false,
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Color(0xFF0097b2),
//                 Color(0xFF0097b2).withOpacity(1),
//                 Color(0xFF0097b2).withOpacity(0.8)
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//         actions: [
//           IconButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => SelectedEmployeeCampSearchScreen(
//                             employeeName: widget.employeeName,
//                             camps: camps,
//                           )),
//                 );
//               },
//               icon: const Icon(Icons.search, color: Colors.white)),
//         ],
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : camps.isEmpty
//               ? Center(
//                   child: Text(
//                     'No camp data found for ${widget.employeeName}.',
//                     style: TextStyle(fontFamily: 'LeagueSpartan', fontSize: 16),
//                   ),
//                 )
//               : ListView.builder(
//                   itemCount: camps.length,
//                   itemBuilder: (context, index) {
//                     final camp = camps[index];
//                     return Card(
//                       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                       child: GestureDetector(
//                         onTap: () async {
//                           await Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => CampSearchEventDetailsPage(
//                                 employee: camp,
//                                 // employeedocId: state.employeeDocId[1],
//                                 campId: campDocIds[index],
//                               ),
//                             ),
//                           );
//                         },
//                         child: Column(
//                           children: [
//                             Container(
//                               height: screenHeight / 3.6,
//                               width: double.infinity,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(12),
//                                 color: Colors.white,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.1),
//                                     spreadRadius: 2,
//                                     blurRadius: 10,
//                                     offset: const Offset(0, 4),
//                                   ),
//                                 ],
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(12),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Row(
//                                           children: [
//                                             Icon(
//                                               Icons.date_range,
//                                               size: screenWidth * 0.07,
//                                               color: Colors.orange,
//                                             ),
//                                             const SizedBox(width: 8),
//                                             Text(
//                                               camp['campDate'] ?? 'No Date',
//                                               style: TextStyle(
//                                                 fontWeight: FontWeight.w500,
//                                                 color: Colors.black54,
//                                                 fontFamily: 'LeagueSpartan',
//                                                 fontSize: screenWidth * 0.05,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         Row(
//                                           children: [
//                                             Icon(
//                                               Icons.watch_later,
//                                               size: screenWidth * 0.07,
//                                               color: Colors.orange,
//                                             ),
//                                             const SizedBox(width: 8),
//                                             Text(
//                                               camp['campTime'] ?? 'No Time',
//                                               style: TextStyle(
//                                                 fontWeight: FontWeight.w500,
//                                                 fontFamily: 'LeagueSpartan',
//                                                 color: Colors.black54,
//                                                 fontSize: screenWidth * 0.05,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                     const SizedBox(height: 5),
//                                     ..._buildInfoText(
//                                       screenWidth,
//                                       camp['campName'] ?? 'Unnamed Camp',
//                                     ),
//                                     ..._buildInfoText(
//                                       screenWidth,
//                                       camp['address'] ?? 'No Address',
//                                     ),
//                                     ..._buildInfoText(
//                                       screenWidth,
//                                       camp['name'] ?? 'No Name',
//                                     ),
//                                     ..._buildInfoText(
//                                       screenWidth,
//                                       camp['phoneNumber1'] ?? 'No Phone Number',
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//     );
//   }
//
//   List<Widget> _buildInfoText(double screenWidth, String text) {
//     return [
//       Text(
//         text,
//         style: TextStyle(
//           fontWeight: FontWeight.w500,
//           color: Colors.black54,
//           fontFamily: 'LeagueSpartan',
//           fontSize: screenWidth * 0.05,
//         ),
//       ),
//     ];
//   }
// }
