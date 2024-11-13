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
        final employeesSnapshot = await FirebaseFirestore.instance.collection('employees').get();

        // Fetch the 'camps' sub-collection for each employee
        List<Map<String, dynamic>> allCamps = [];

        for (var employeeDoc in employeesSnapshot.docs) {
          final employeeId = employeeDoc.id;
          final campsSnapshot = await FirebaseFirestore.instance
              .collection('employees')
              .doc(employeeId)
              .collection('camps')
              .get();

          final camps = campsSnapshot.docs.map((doc) => doc.data()).toList();
          allCamps.addAll(camps);
        }

        print("Fetched all camps: $allCamps");
        emit(AdminApprovalLoaded(allCamps));
      } catch (e) {
        print("Error in fetching camps");
        emit(AdminApprovalError(e.toString()));
      }
    });
  }
}
