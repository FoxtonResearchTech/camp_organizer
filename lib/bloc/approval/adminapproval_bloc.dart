import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'adminapproval_event.dart';
import 'adminapproval_state.dart';

class AdminApprovalBloc extends Bloc<AdminApprovalEvent, AdminApprovalState> {
  AdminApprovalBloc() : super(AdminApprovalInitial()) {
    on<FetchDataEvents>((event, emit) async {
      emit(AdminApprovalLoading());
      try {
        // Access the 'employees' collection
        final employeesSnapshot =
            await FirebaseFirestore.instance.collection('employees').get();

        // Fetch the 'camps' sub-collection for each employee
        List<Map<String, dynamic>> allCamps = [];

        for (var employeeDoc in employeesSnapshot.docs) {
          final employeeId = employeeDoc.id;
          final campsSnapshot = await FirebaseFirestore.instance
              .collection('employees')
              .doc(employeeId)
              .collection('camps')
              .get();

          final camps = campsSnapshot.docs.map((doc) {
            final data = doc.data();
            data['documentId'] = doc.id; // Add the document ID to the data
            return data;
          }).toList();

          allCamps.addAll(camps);
        }

        print("Fetched all camps: $allCamps");
        emit(AdminApprovalLoaded(allCamps));
      } catch (e) {
        print("Error in fetching camps: $e");
        emit(AdminApprovalError(e.toString()));
      }
    });
    on<UpdateStatusEvent>((event, emit) async {
      try {
        // Fetch all documents from the 'employees' collection
        final employeesSnapshot =
            await FirebaseFirestore.instance.collection('employees').get();

        for (var employeeDoc in employeesSnapshot.docs) {
          // Get the employee ID (document ID)
          String employeeId = employeeDoc.id;

          // Fetch all camp documents for each employee
          final campsSnapshot = await FirebaseFirestore.instance
              .collection('employees')
              .doc(employeeId)
              .collection('camps')
              .get();

          for (var campDoc in campsSnapshot.docs) {
            String campDocumentId = campDoc.id;

            // Update the 'campStatus' field in each camp document
            await FirebaseFirestore.instance
                .collection('employees')
                .doc(employeeId)
                .collection('camps')
                .doc(campDocumentId)
                .update({'campStatus': 'Approved'});
          }
        }

        emit(AdminApprovalUpdated());
      } catch (e) {
        emit(AdminApprovalError("Failed to update status: \${e.toString()}"));
      }
    });
    on<AddReasonEvent>((event, emit) async {
      try {
        final reasonText = event.reasonText;

        final employeesSnapshot =
            await FirebaseFirestore.instance.collection('employees').get();

        for (var employeeDoc in employeesSnapshot.docs) {
          // Get the employee ID (document ID)
          String employeeId = employeeDoc.id;

          // Fetch all camp documents for each employee
          final campsSnapshot = await FirebaseFirestore.instance
              .collection('employees')
              .doc(employeeId)
              .collection('camps')
              .get();

          for (var campDoc in campsSnapshot.docs) {
            String campDocumentId = campDoc.id;

            // Update the 'campStatus' field in each camp document
            await FirebaseFirestore.instance
                .collection('employees')
                .doc(employeeId)
                .collection('camps')
                .doc(campDocumentId)
                .update({'reason': reasonText});
          }
        }

        // Emit success after all updates
        emit(AdminApprovalUpdated());
      } catch (e) {
        // Handle any errors that might occur during the process
        emit(AdminApprovalError("Failed to add reason: ${e.toString()}"));
      }
    });
  }
}
