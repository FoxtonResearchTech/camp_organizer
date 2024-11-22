import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'add_finance_event.dart';
import 'add_finance_state.dart';

class AddFinanceBloc extends Bloc<AddFinanceEvent, AddFinanceState> {
  final FirebaseFirestore firestore;

  AddFinanceBloc({required this.firestore}) : super(AddFinanceInitial()) {
    on<AddFinanceWithDocumentId>(_onAddFinanceWithDocumentId);
  }

  Future<void> _onAddFinanceWithDocumentId(
      AddFinanceWithDocumentId event, Emitter<AddFinanceState> emit) async {
    emit(AddFinanceLoading());
    try {
      // Fetch all employees
      final employeesSnapshot = await firestore.collection('employees').get();

      if (employeesSnapshot.docs.isEmpty) {
        emit(AddFinanceError(message: "No employees found"));
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
        emit(AddFinanceError(message: "Finance record not found"));
        return;
      }

      // Add or update the finance information
      final financeRef = firestore
          .collection('employees')
          .doc(targetEmployeeId)
          .collection('camps')
          .doc(targetFinanceDocId);

      await financeRef.update(event.data);

      emit(AddFinanceSuccess());
    } catch (e) {
      emit(AddFinanceError(message: e.toString()));
    }
  }
}
