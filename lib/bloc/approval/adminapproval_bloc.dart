import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'adminapproval_event.dart';
import 'adminapproval_state.dart';

class AdminApprovalBloc extends Bloc<AdminApprovalEvent, AdminApprovalState> {
  AdminApprovalBloc() : super(AdminApprovalInitial()) {

    // Fetch camps data from Firestore
    on<FetchDataEvents>((event, emit) async {
      emit(AdminApprovalLoading());
      try {
        final employeesSnapshot = await FirebaseFirestore.instance.collection('employees').get();

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

    // Update status to 'Approved' or 'Rejected'
    on<UpdateStatusEvent>((event, emit) async {
      try {
        String employeeId = event.employeeId;
        String campDocId = event.campDocId;
        String newStatus = event.newStatus;  // Dynamic status

        // Fetch the specific camp document
        final campDoc = await FirebaseFirestore.instance
            .collection('employees')
            .doc(employeeId)
            .collection('camps')
            .doc(campDocId)
            .get();

        if (campDoc.exists) {
          // Update the 'campStatus' field in the specific camp document
          await FirebaseFirestore.instance
              .collection('employees')
              .doc(employeeId)
              .collection('camps')
              .doc(campDocId)
              .update({'campStatus': newStatus});

          emit(AdminApprovalUpdated());
        } else {
          emit(AdminApprovalError("Camp document not found"));
        }
      } catch (e) {
        emit(AdminApprovalError("Failed to update status: ${e.toString()}"));
      }
    });

    // Add reason for rejection or any status update
    on<AddReasonEvent>((event, emit) async {
      try {
        String reasonText = event.reasonText;  // Reason passed from the event
        String employeeId = event.employeeId;  // Use the employeeId passed in the event
        String campDocId = event.campDocId;    // Use the campDocId passed in the event

        // Check if the reason is not empty
        if (reasonText.isEmpty) {
          emit(AdminApprovalError("Reason cannot be empty"));
          return;
        }

        // Fetch the specific camp document
        final campDoc = await FirebaseFirestore.instance
            .collection('employees')
            .doc(employeeId)
            .collection('camps')
            .doc(campDocId)
            .get();

        if (campDoc.exists) {
          // Update the 'reason' field in the specific camp document
          await FirebaseFirestore.instance
              .collection('employees')
              .doc(employeeId)
              .collection('camps')
              .doc(campDocId)
              .update({'reason': reasonText});

          emit(AdminApprovalUpdated());
        } else {
          emit(AdminApprovalError("Camp document not found"));
        }
      } catch (e) {
        emit(AdminApprovalError("Failed to add reason: ${e.toString()}"));
      }
    });
  }
}
