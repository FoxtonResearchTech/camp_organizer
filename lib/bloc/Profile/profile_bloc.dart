import 'package:bloc/bloc.dart';
import 'package:camp_organizer/bloc/Profile/profile_event.dart';
import 'package:camp_organizer/bloc/Profile/profile_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<FetchDataEvent>((event, emit) async {
      emit(ProfileLoading());
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
          emit(ProfileLoaded(employeeData ?? <String, dynamic>{}));
          print(employeeData);
          print('Current User UID: ${currentUser.uid}');
        } else {
          emit(ProfileError('No user is currently signed in.'));
        }
      } catch (e) {
        print("Error in fetching data for current user: $e");
        emit(ProfileError(e.toString()));
      }
    });
  }
}
