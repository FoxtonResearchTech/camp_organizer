import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'status_event.dart';
import 'status_state.dart';

class StatusBloc extends Bloc<StatusEvent, StatusState> {
  StatusBloc() : super(StatusInitial()) {
    on<FetchDataEvent>((event, emit) async {
      emit(StatusLoading());
      try {
        final querySnapshot =
            await FirebaseFirestore.instance.collection('employees').get();
        final employees = querySnapshot.docs.map((doc) => doc.data()).toList();
        print("Fetched employees: $employees");
        emit(StatusLoaded(employees));
      } catch (e) {
        print("Error is fetching");
        emit(StatusError(e.toString()));
      }
    });
  }
}
