import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'camp_incharge_profile_event.dart';
import 'camp_incharge_profile_state.dart';

class CampInChargeProfileBloc
    extends Bloc<CampInChargeProfileEvent, CampInChargeProfileState> {
  CampInChargeProfileBloc() : super(CampInChargeProfileInitial()) {
    on<FetchDataEvent>((event, emit) async {
      emit(CampInChargeProfileLoading());
      try {
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          final querySnapshot = await FirebaseFirestore.instance
              .collection('employees')
              .where('empCode', isEqualTo: currentUser.email)
              .get();

          final employeeData = querySnapshot.docs.isNotEmpty
              ? querySnapshot.docs.first.data() as Map<String, dynamic>?
              : <String, dynamic>{};
          emit(CampInChargeProfileLoaded(employeeData ?? <String, dynamic>{}));
          print(employeeData);
          print('Current User UID: ${currentUser.uid}');
        } else {
          emit(CampInChargeProfileError('No user is currently signed in.'));
        }
      } catch (e) {
        print("Error in fetching data for current user: $e");
        emit(CampInChargeProfileError(e.toString()));
      }
    });
  }
}
