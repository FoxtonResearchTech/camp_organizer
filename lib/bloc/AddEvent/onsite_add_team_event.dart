import 'package:equatable/equatable.dart';

abstract class AddTeamEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddTeamWithDocumentId extends AddTeamEvent {
  final String documentId; // The document ID for the camp in Firestore
  final String teamInfo; // The team data to be added

  AddTeamWithDocumentId({required this.documentId, required this.teamInfo});

  @override
  List<Object?> get props => [documentId, teamInfo];
}
