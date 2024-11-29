import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'onsite_profile_event.dart';
import 'onsite_profile_state.dart';

class OnsiteProfileBloc extends Bloc<OnsiteProfileEvent, OnsiteProfileState> {
  OnsiteProfileBloc() : super(OnsiteProfileInitial()) {
    on<FetchDataEvent>((event, emit) async {
      emit(OnsiteProfileLoading());
      try {
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          final empCode = currentUser.email;
          final normalizedEmpCode = empCode?.split('@').first ?? '';
          final querySnapshot = await FirebaseFirestore.instance
              .collection('employees')
              .where('empCode', isEqualTo: normalizedEmpCode)
              .get();

          final employeeData = querySnapshot.docs.isNotEmpty
              ? querySnapshot.docs.first.data() as Map<String, dynamic>?
              : <String, dynamic>{};
          emit(OnsiteProfileLoaded(employeeData ?? <String, dynamic>{}));
          print(employeeData);
          print('Current User UID: ${currentUser.uid}');
        } else {
          emit(OnsiteProfileError('No user is currently signed in.'));
        }
      } catch (e) {
        print("Error in fetching data for current user: $e");
        emit(OnsiteProfileError(e.toString()));
      }
    });
  }
}
