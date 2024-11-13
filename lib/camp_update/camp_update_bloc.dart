import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'camp_update_event.dart';
import 'camp_update_state.dart';

class CampUpdateBloc extends Bloc<CampUpdateEvent, CampUpdateState> {
  CampUpdateBloc() : super(CampUpdateInitial()) {
    on<FetchDataEvent>((event, emit) async {
      emit(CampUpdateLoading());
      try {
        // Access the 'employees' collection
        final employeesSnapshot = await FirebaseFirestore.instance.collection('employees').get();

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
        emit(CampUpdateLoaded(allCamps));
      } catch (e) {
        print("Error in fetching camps");
        emit(CampUpdateError(e.toString()));
      }
    });

    on<UpdateCampEvent>((event, emit) async {
      emit(CampUpdateLoading());
      try {
        // Access the specific camp document by employeeId and campId and update the camp data
        await FirebaseFirestore.instance
            .collection('employees')
            .doc(event.employeeId) // Access the specific employee
            .collection('camps')
            .doc(event.campId) // Access the specific camp
            .update(event.updatedData); // Update the camp data

        // Emit success or updated state
        emit(CampUpdateSuccess("Camp updated successfully"));
      } catch (e) {
        print("Error updating camp: $e");
        emit(CampUpdateError(e.toString()));
      }
    });
  }
}
