// adminapproval_event.dart

abstract class AdminApprovalEvent {}

class FetchDataEvents extends AdminApprovalEvent {}

class UpdateStatusEvent extends AdminApprovalEvent {
  final String employeeId;
  final String campDocId;
  final String newStatus;

  UpdateStatusEvent({
    required this.employeeId,
    required this.campDocId,
    required this.newStatus, // Added dynamic status
  });
}

class AddReasonEvent extends AdminApprovalEvent {
  final String reasonText;
  final String employeeId;
  final String campDocId;

  AddReasonEvent({
    required this.reasonText,
    required this.employeeId,
    required this.campDocId,
  });
}
