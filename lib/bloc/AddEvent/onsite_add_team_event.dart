import 'package:equatable/equatable.dart';

abstract class AddTeamEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddTeamWithDocumentId extends AddTeamEvent {
  final String documentId; // The document ID for the camp in Firestore
  final Map<String, dynamic> data; // The team data to be added

  AddTeamWithDocumentId({required this.documentId, required this.data});

  @override
  List<Object?> get props => [documentId, data];
}
