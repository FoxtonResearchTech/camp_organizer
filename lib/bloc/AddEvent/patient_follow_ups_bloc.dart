import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'patient_follow_ups_event.dart';
import 'patient_follow_ups_state.dart';

class PatientFollowUpsBloc extends Bloc<PatientFollowUpsEvent, PatientFollowUpsState> {
  final FirebaseFirestore firestore;

  PatientFollowUpsBloc({required this.firestore}) : super(PatientFollowUpsInitial()) {
    on<AddPatientFollowUpsWithDocumentId>(_onAddPatientFollowUpsWithDocumentId);
  }

  Future<void> _onAddPatientFollowUpsWithDocumentId(
      AddPatientFollowUpsWithDocumentId event, Emitter<PatientFollowUpsState> emit) async {
    emit(PatientFollowUpsLoading());
    try {
      // Fetch all employees
      final employeesSnapshot = await firestore.collection('employees').get();

      if (employeesSnapshot.docs.isEmpty) {
        emit(PatientFollowUpsError(message: "No employees found"));
        return;
      }

      // Loop through employees to find the desired employee/finance
      String? targetEmployeeId;
      String? targetFinanceDocId;

      for (var employeeDoc in employeesSnapshot.docs) {
        final employeeId = employeeDoc.id;

        // Fetch finance records for the current employee
        final financesSnapshot = await firestore
            .collection('employees')
            .doc(employeeId)
            .collection('camps')
            .get();

        // Look for the matching finance document
        for (var financeDoc in financesSnapshot.docs) {
          if (financeDoc.id == event.documentId) {
            targetEmployeeId = employeeId;
            targetFinanceDocId = financeDoc.id;
            break;
          }
        }

        if (targetEmployeeId != null) break; // Stop searching once found
      }

      if (targetEmployeeId == null || targetFinanceDocId == null) {
        emit(PatientFollowUpsError(message: "Finance record not found"));
        return;
      }

      // Add or update the finance information
      final financeRef = firestore
          .collection('employees')
          .doc(targetEmployeeId)
          .collection('camps')
          .doc(targetFinanceDocId);

      await financeRef.update(event.data);

      emit(PatientFollowUpsSuccess());
    } catch (e) {
      emit(PatientFollowUpsError(message: e.toString()));
    }
  }
}
