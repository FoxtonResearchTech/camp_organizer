import 'package:bloc/bloc.dart';
import 'package:camp_organizer/bloc/Employee/employee_update_event.dart';
import 'package:camp_organizer/bloc/Employee/employee_update_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeUpdateBloc
    extends Bloc<EmployeeUpdateEvent, EmployeeUpdateState> {
  EmployeeUpdateBloc() : super(EmployeeUpdateInitial()) {
    on<FetchDataEvent>((event, emit) async {
      emit(EmployeeUpdateLoading());
      try {
        final querySnapshot =
            await FirebaseFirestore.instance.collection('employees').get();

        // Map the query snapshot to a list of employee data
        final List<Map<String, dynamic>> employeesData = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();

        // Emit the loaded state with the list of employee data
        emit(EmployeeUpdateLoaded(employeesData));
        print(employeesData);
      } catch (e) {
        print("Error in fetching data for employees: $e");
        emit(EmployeeUpdateError(e.toString()));
      }
    });
  }
}
