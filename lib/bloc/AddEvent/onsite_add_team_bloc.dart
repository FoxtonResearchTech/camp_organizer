import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'onsite_add_team_event.dart';
import 'onsite_add_team_state.dart';

class AddTeamBloc extends Bloc<AddTeamEvent, AddTeamState> {
  final FirebaseFirestore firestore;

  AddTeamBloc({required this.firestore}) : super(AddTeamInitial()) {
    on<AddTeamWithDocumentId>(_onAddTeamWithDocumentId);
  }

  Future<void> _onAddTeamWithDocumentId(
      AddTeamWithDocumentId event, Emitter<AddTeamState> emit) async {
    emit(AddTeamLoading());
    try {
      // Fetch all employees
      final employeesSnapshot = await firestore.collection('employees').get();

      if (employeesSnapshot.docs.isEmpty) {
        emit(AddTeamError(message: "No employees found"));
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
        emit(AddTeamError(message: "Camp not found"));
        return;
      }

      // Add the team information to the "teams" array field
      final campRef = firestore
          .collection('employees')
          .doc(targetEmployeeId)
          .collection('camps')
          .doc(targetCampDocId);

      await campRef.update({
        'teams': FieldValue.arrayUnion([event.teamInfo]),
      });

      emit(AddTeamSuccess());
    } catch (e) {
      emit(AddTeamError(message: e.toString()));
    }
  }
}
