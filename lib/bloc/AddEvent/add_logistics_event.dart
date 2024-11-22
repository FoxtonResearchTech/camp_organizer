import 'package:equatable/equatable.dart';

abstract class AddLogisticsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddLogisticsWithDocumentId extends AddLogisticsEvent {
  final String documentId;
  final Map<String, dynamic> data;

  AddLogisticsWithDocumentId({required this.documentId, required this.data});

  @override
  List<Object> get props => [documentId, data];
}
