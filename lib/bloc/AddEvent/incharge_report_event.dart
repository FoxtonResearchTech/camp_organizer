import 'package:equatable/equatable.dart';

abstract class InchargeReportEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchInchargeReport extends InchargeReportEvent {
  final String employeeId; // The employee ID in Firestore
  final String campId; // The camp ID for which the report is fetched

  FetchInchargeReport({required this.employeeId, required this.campId});

  @override
  List<Object?> get props => [employeeId, campId];
}

class UpdateInchargeReport extends InchargeReportEvent {
  final String documentId; // The employee ID in Firestore

  final Map<String, dynamic> data; // The updated report data

  UpdateInchargeReport({
    required this.documentId,
    required this.data,
  });

  @override
  List<Object?> get props => [documentId, data];
}
