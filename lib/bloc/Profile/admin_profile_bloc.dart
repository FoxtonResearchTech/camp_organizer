import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'admin_profile_event.dart';
import 'admin_profile_state.dart';

class AdminProfileBloc extends Bloc<AdminProfileEvent, AdminProfileState> {
  AdminProfileBloc() : super(AdminProfileInitial()) {
    on<FetchDataEvent>((event, emit) async {
      emit(AdminProfileLoading());
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
          emit(AdminProfileLoaded(employeeData ?? <String, dynamic>{}));
          print(employeeData);
          print('Current User UID: ${currentUser.uid}');
        } else {
          emit(AdminProfileError('No user is currently signed in.'));
        }
      } catch (e) {
        print("Error in fetching data for current user: $e");
        emit(AdminProfileError(e.toString()));
      }
    });
  }
}
