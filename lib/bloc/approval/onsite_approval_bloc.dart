import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'onsite_approval_event.dart';
import 'onsite_approval_state.dart';


class OnsiteApprovalBloc extends Bloc<OnsiteApprovalEvent, OnsiteApprovalState> {
  OnsiteApprovalBloc() : super(OnsiteApprovalInitial()) {
    // Handle FetchDataEvents
    on<FetchDataEvents>((event, emit) async {
      emit(OnsiteApprovalLoading());
      try {
        // Access the 'onsiteRequests' collection
        final onsiteRequestsSnapshot =
        await FirebaseFirestore.instance.collection('onsiteRequests').get();

        // Fetch and prepare data from the collection
        List<Map<String, dynamic>> allApprovals = onsiteRequestsSnapshot.docs.map((doc) {
          final data = doc.data();
          data['documentId'] = doc.id; // Add the document ID to the data
          return data;
        }).toList();

        print("Fetched onsite approvals: $allApprovals");
        emit(OnsiteApprovalLoaded(allApprovals));
      } catch (e) {
        print("Error in fetching onsite approvals: $e");
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
