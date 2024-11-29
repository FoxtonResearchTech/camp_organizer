import 'package:bloc/bloc.dart';
import 'package:camp_organizer/bloc/Profile/post_camp_profile_event.dart';
import 'package:camp_organizer/bloc/Profile/post_camp_profile_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostCampProfileBloc
    extends Bloc<PostCampProfileEvent, PostCampProfileState> {
  PostCampProfileBloc() : super(PostCampProfileInitial()) {
    on<FetchDataEvent>((event, emit) async {
      emit(PostCampProfileLoading());
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
          emit(PostCampProfileLoaded(employeeData ?? <String, dynamic>{}));
          print(employeeData);
          print('Current User UID: ${currentUser.uid}');
        } else {
          emit(PostCampProfileError('No user is currently signed in.'));
        }
      } catch (e) {
        print("Error in fetching data for current user: $e");
        emit(PostCampProfileError(e.toString()));
      }
    });
  }
}
