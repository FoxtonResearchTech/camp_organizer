// firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> registerEmployee(Map<String, dynamic> employeeData) async {
    try {
      await _db.collection('employees').add(employeeData);
    } catch (e) {
      throw Exception('Error registering employee: $e');
    }
  }
}
