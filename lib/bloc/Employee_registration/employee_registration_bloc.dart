// registration_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


import 'employee_registration_event.dart';
import 'employee_registration_state.dart';


class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RegistrationBloc() : super(RegistrationInitial());

  @override
  Stream<RegistrationState> mapEventToState(RegistrationEvent event) async* {
    if (event is RegisterEmployeeEvent) {
      yield RegistrationLoading();

      // Validate passwords match
      if (event.password != event.reEnterPassword) {
        yield RegistrationFailure(error: "Passwords do not match.");
        return;
      }

      try {
        // Register with Firebase Authentication (empCode as email)
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: event.empCode,  // empCode as email
          password: event.password,
        );

        // Save employee data to Firestore
        await _firestore.collection('employees').doc(userCredential.user?.uid).set({
          'firstName': event.firstName,
          'lastName': event.lastName,
          'dob': event.dob,
          'gender': event.gender,
          'position': event.position,
          'empCode': event.empCode,  // email (empCode)
          'lane1': event.lane1,
          'lane2': event.lane2,
          'state': event.state,
          'pinCode': event.pinCode,
        });

        yield RegistrationSuccess(message: "Employee Registered Successfully!");
      } catch (e) {
        yield RegistrationFailure(error: e.toString());
      }
    }
  }
}
