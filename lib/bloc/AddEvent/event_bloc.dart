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

  Future<void> _onSubmitForm(
      SubmitForm event, Emitter<EventFormState> emit) async {
    emit(FormSubmitting());
    try {
      await submitEventData(event, emit);
    } catch (e) {
      emit(FormSubmitFailure(
          e.toString())); // Emit failure state with the error message
    }
  }

  Future<void> submitEventData(
      SubmitForm event, Emitter<EventFormState> emit) async {
    User? user =
        FirebaseAuth.instance.currentUser; // Get the current logged-in user

    if (user == null) {
      emit(FormSubmitFailure("No user is logged in"));
      return;
    }

    // Navigate to the current user's document in 'employees' collection
    DocumentReference employeeDocRef =
        _firestore.collection('employees').doc(user.uid);

    try {
      // Create a subcollection under the employee document (e.g. 'events')
      CollectionReference eventsCollection = employeeDocRef.collection('camps');

      // Add the event data to the 'events' subcollection
      await eventsCollection.add({
        'campName': event.campName,
        'campDate': event.campDate,
        'campTime': event.campTime,
        'organization': event.organization,
        'address': event.address,
        'city': event.city,
        'state': event.state,
        'pincode': event.pincode,
        'name': event.name,
        'position': event.position,
        'position2': event.position2,
        'campPlanType': event.campPlanType,
        'roadAccess': event.roadAccess,
        'waterAvailability': event.waterAvailability,
        'lastCampDone': event.lastCampDone,
        'phoneNumber1': event.phoneNumber1,
        'phoneNumber2': event.phoneNumber2,
        'name2': event.name2,
        'phoneNumber1_2': event.phoneNumber1_2,
        'phoneNumber2_2': event.phoneNumber2_2,
        'totalSquareFeet': event.totalSquareFeet,
        'noOfPatientExpected': event.noOfPatientExpected,
        'CreatedOn': DateTime.now(),
        'EmployeeId': user.email,
        'campStatus': 'Waiting',
      });

      emit(FormSubmitSuccess()); // Emit success state when data is saved
    } catch (e) {
      emit(FormSubmitFailure("Error saving event: ${e.toString()}"));
    }
  }
}
