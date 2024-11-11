import 'dart:convert';
import 'package:camp_organizer/bloc/AddEvent/event_event.dart';
import 'package:camp_organizer/bloc/AddEvent/event_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventFormBloc extends Bloc<EventEvent, EventFormState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  EventFormBloc() : super(EventFormInitial()) {
    on<SubmitForm>(_onSubmitForm); // Register the event handler here
  }

  Future<void> _onSubmitForm(SubmitForm event, Emitter<EventFormState> emit) async {
    emit(FormSubmitting());
    try {
      await submitEventData(event, emit);
    } catch (e) {
      emit(FormSubmitFailure(e.toString())); // Emit failure state with the error message
    }
  }

  Future<void> submitEventData(SubmitForm event, Emitter<EventFormState> emit) async {
    CollectionReference patientsCollection = _firestore.collection('AddEvent');
    User? user = FirebaseAuth.instance.currentUser;  // Get the current logged-in user

    // Directly add the event data to Firestore with the updated field names
    await patientsCollection.add({
      'campName': event.campName,
      'organization': event.organization,
      'address': event.address,
      'city': event.city,
      'state': event.state,
      'pincode': event.pincode,
      'name': event.name,
      'phoneNumber1': event.phoneNumber1,
      'phoneNumber2': event.phoneNumber2,
      'name2': event.name2,
      'phoneNumber1_2': event.phoneNumber1_2,
      'phoneNumber2_2': event.phoneNumber2_2,
      'totalSquareFeet': event.totalSquareFeet,
      'noOfPatientExpected': event.noOfPatientExpected,
      'CreatedOn': DateTime.now(),
      'EmployeeId': user?.email,
    });

    emit(FormSubmitSuccess());  // Emit success state when data is saved
  }

}
