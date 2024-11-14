import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'status_event.dart';
import 'status_state.dart';

class StatusBloc extends Bloc<StatusEvent, StatusState> {
  StatusBloc() : super(StatusInitial()) {
    on<FetchDataEvent>((event, emit) async {
      emit(StatusLoading());
      try {
        // Retrieve the current user's ID from FirebaseAuth
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          emit(StatusError("User not logged in"));
          return;
        }

        final userId = user.uid;

        // Fetch employee data
        List<Map<String, dynamic>> employees = await fetchEmployees(userId);

        // Fetch document IDs for employee and camp
        String employeeDocId = await fetchEmployeeDocId(userId);
        String campDocId = await fetchCampDocId(userId);

        // Emit the loaded state with the retrieved data
        emit(StatusLoaded(employees, employeeDocId, campDocId));
      } catch (e) {
        emit(StatusError('Failed to load data: $e'));
      }
    });
  }

  // Fetch employee data
  Future<List<Map<String, dynamic>>> fetchEmployees(String userId) async {
    final employeesSnapshot = await FirebaseFirestore.instance
        .collection('employees')
        .doc(userId)
        .collection('camps')
        .get();

    return employeesSnapshot.docs.map((doc) => doc.data()).toList();
  }

  // Fetch employee document ID
  Future<String> fetchEmployeeDocId(String userId) async {
    final employeeDocSnapshot = await FirebaseFirestore.instance
        .collection('employees')
        .doc(userId)
        .get();

    return employeeDocSnapshot.id; // Return the document ID
  }

  // Fetch camp document ID
  Future<String> fetchCampDocId(String userId) async {
    final campDocSnapshot = await FirebaseFirestore.instance
        .collection('employees')
        .doc(userId)
        .collection('camps')
        .get();

    // Assuming there's only one camp document, get its ID
    return campDocSnapshot.docs.isNotEmpty ? campDocSnapshot.docs.first.id : '';
  }
}
