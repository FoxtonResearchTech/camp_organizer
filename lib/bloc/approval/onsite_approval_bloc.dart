import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'onsite_approval_event.dart';
import 'onsite_approval_state.dart';


class OnsiteApprovalBloc extends Bloc<OnsiteApprovalEvent, OnsiteApprovalState> {
  OnsiteApprovalBloc() : super(OnsiteApprovalInitial()) {
    // Handle FetchDataEvents
    on<FetchOnsiteApprovalData>((event, emit) async {
      emit(OnsiteApprovalLoading());
      try {
        final employeesSnapshot = await FirebaseFirestore.instance.collection('employees').get();

        List<Map<String, dynamic>> allCamps = [];
        List<String> campDocIds = [];
        List<String> employeeDocIds = []; // Store all employee IDs

        // Loop through employees
        for (var employeeDoc in employeesSnapshot.docs) {
          final employeeId = employeeDoc.id; // This is the employeeDocId
          employeeDocIds.add(employeeId);  // Collect employeeDocId

          final campsSnapshot = await FirebaseFirestore.instance
              .collection('employees')
              .doc(employeeId)
              .collection('camps')
              .get();

          final camps = campsSnapshot.docs.map((doc) {
            final data = doc.data();
            data['documentId'] = doc.id; // Add the camp document ID to the data
            data['employeeDocId'] = employeeId; // Add employeeDocId to the data
            campDocIds.add(doc.id); // Store the camp document IDs
            return data;
          }).toList();

          allCamps.addAll(camps);
        }

        // Emit the AdminApprovalLoaded state with the camps, employeeDocIds, and campDocIds
        emit(OnsiteApprovalLoaded(allCamps, employeeDocIds, campDocIds));
      } catch (e) {
        print("Error in fetching camps: $e");
        emit(OnsiteApprovalError(e.toString()));
      }
    });

    // Handle UpdateStatusEvent
    on<UpdateStatusEvent>((event, emit) async {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          emit(OnsiteApprovalError("User not logged in"));
          return;
        }

        final userId = user.uid;

        // Update the 'status' field in the specified document
        await FirebaseFirestore.instance
            .collection('onsiteRequests')
            .doc(event.documentId)
            .update({'status': 'Approved'});

        emit(OnsiteApprovalUpdated());
      } catch (e) {
        emit(OnsiteApprovalError("Failed to update status: ${e.toString()}"));
      }
    });
  }
}
