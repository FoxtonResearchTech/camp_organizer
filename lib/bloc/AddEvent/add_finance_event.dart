import 'package:equatable/equatable.dart';

abstract class AddFinanceEvent extends Equatable {
  const AddFinanceEvent();

  @override
  List<Object?> get props => [];
}

class AddFinanceWithDocumentId extends AddFinanceEvent {
  final String documentId;
  final Map<String, dynamic> data;

  const AddFinanceWithDocumentId({required this.documentId, required this.data});

  @override
  List<Object?> get props => [documentId, data];
}
