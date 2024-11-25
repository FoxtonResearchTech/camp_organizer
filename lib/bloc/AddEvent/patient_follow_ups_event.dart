import 'package:equatable/equatable.dart';

abstract class PatientFollowUpsEvent extends Equatable {
  const PatientFollowUpsEvent();

  @override
  List<Object?> get props => [];
}

class AddPatientFollowUpsWithDocumentId extends PatientFollowUpsEvent {
  final String documentId;
  final Map<String, dynamic> data;

  const AddPatientFollowUpsWithDocumentId({required this.documentId, required this.data});

  @override
  List<Object?> get props => [documentId, data];
}
