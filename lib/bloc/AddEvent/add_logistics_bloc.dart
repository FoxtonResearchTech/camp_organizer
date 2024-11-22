import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'add_logistics_event.dart';
import 'add_logistics_state.dart';

class AddLogisticsBloc extends Bloc<AddLogisticsEvent, AddLogisticsState> {
  final FirebaseFirestore firestore;

  AddLogisticsBloc({required this.firestore}) : super(AddLogisticsInitial()) {
    on<AddLogisticsWithDocumentId>(_onAddLogisticsWithDocumentId);
  }

  Future<void> _onAddLogisticsWithDocumentId(
      AddLogisticsWithDocumentId event, Emitter<AddLogisticsState> emit) async {
    emit(AddLogisticsLoading());
    try {
      // Fetch all employees
      final employeesSnapshot = await firestore.collection('employees').get();

      if (employeesSnapshot.docs.isEmpty) {
        emit(AddLogisticsError(message: "No employees found"));
        return;
      }

      // Loop through employees to find the desired employee/camp
      String? targetEmployeeId;
      String? targetCampDocId;

      for (var employeeDoc in employeesSnapshot.docs) {
        final employeeId = employeeDoc.id;

        // Fetch camps for the current employee
        final campsSnapshot = await firestore
            .collection('employees')
            .doc(employeeId)
            .collection('camps')
            .get();

        // Look for the matching camp
        for (var campDoc in campsSnapshot.docs) {
          if (campDoc.id == event.documentId) {
            targetEmployeeId = employeeId;
            targetCampDocId = campDoc.id;
            break;
          }
        }

        if (targetEmployeeId != null) break; // Stop searching once found
      }

      if (targetEmployeeId == null || targetCampDocId == null) {
        emit(AddLogisticsError(message: "Camp not found"));
        return;
      }

      // Add the team information to the "teams" array field
      final campRef = firestore
          .collection('employees')
          .doc(targetEmployeeId)
          .collection('camps')
          .doc(targetCampDocId);

      await campRef.update(event.data);

      emit(AddLogisticsSuccess());
    } catch (e) {
      emit(AddLogisticsError(message: e.toString()));
    }
  }
}
