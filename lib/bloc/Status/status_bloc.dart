import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'status_event.dart';
import 'status_state.dart';

class StatusBloc extends Bloc<StatusEvent, StatusState> {
  StatusBloc() : super(StatusInitial()) {
    on<FetchDataEvent>((event, emit) async {
      emit(StatusLoading());
      try {
        // Get the current user's ID (uid) from FirebaseAuth
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          emit(StatusError("User not logged in"));
          return;
        }

        final userId = user.uid;

        // Access the user's 'camps' sub-collection
        final campsSnapshot = await FirebaseFirestore.instance
            .collection('employees')
            .doc(userId)
            .collection('camps')
            .get();

        final camps = campsSnapshot.docs.map((doc) => doc.data()).toList();
        print("Fetched camps: $camps");
        emit(StatusLoaded(camps));
      } catch (e) {
        print("Error in fetching camps");
        emit(StatusError(e.toString()));
      }
    });
  }
}
