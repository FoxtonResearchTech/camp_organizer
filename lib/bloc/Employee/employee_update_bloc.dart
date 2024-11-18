import 'package:bloc/bloc.dart';
import 'package:camp_organizer/bloc/Employee/employee_update_event.dart';
import 'package:camp_organizer/bloc/Employee/employee_update_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeUpdateBloc
    extends Bloc<EmployeeUpdateEvent, EmployeeUpdateState> {
  EmployeeUpdateBloc() : super(EmployeeUpdateInitial()) {
    on<FetchDataEvent>((event, emit) async {
      emit(EmployeeUpdateLoading());
      try {
        final employeesData = await _fetchEmployeesFromFirestore();
        emit(EmployeeUpdateLoaded(employeesData));
      } catch (e) {
        print("Error in fetching data for employees: $e");
        emit(EmployeeUpdateError(e.toString()));
      }
    });

    on<DeleteEmployeeEvent>((event, emit) async {
      try {
        // Fetch the employee document based on the empCode field
        final querySnapshot = await FirebaseFirestore.instance
            .collection('employees')
            .where('empCode', isEqualTo: event.empCode) // Filtering by empCode
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Assuming only one document matches the empCode
          final documentIdToDelete = querySnapshot.docs.first.id;

          // Delete the document using its ID
          await FirebaseFirestore.instance
              .collection('employees')
              .doc(documentIdToDelete)
              .delete();

          // Fetch updated employee data after deletion
          final updatedEmployeesData = await _fetchEmployeesFromFirestore();

          emit(EmployeeUpdateLoaded(updatedEmployeesData)); // Emit updated data
        } else {
          emit(EmployeeUpdateError("Employee not found for deletion"));
        }
      } catch (e) {
        print("Error deleting employee: $e");
        emit(EmployeeUpdateError("Failed to delete employee: ${e.toString()}"));
      }
    });
  }

  // Helper method to fetch employee data from Firestore
  Future<List<Map<String, dynamic>>> _fetchEmployeesFromFirestore() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('employees').get();

    // Map the query snapshot to a list of employee data including the document ID
    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id; // Add document ID to the data map
      return data;
    }).toList();
  }
}
