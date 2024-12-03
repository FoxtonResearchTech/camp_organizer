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

class DeleteCampEvent extends AdminApprovalEvent {
  final String employeeId; // The ID of the employee
  final String campDocId; // The ID of the camp to delete

  DeleteCampEvent({required this.employeeId, required this.campDocId});

  @override
  List<Object> get props => [employeeId, campDocId];
}

class SelectedEmployeeFetchEvent extends FetchDataEvents {
  final String employeeName;

  SelectedEmployeeFetchEvent(this.employeeName);
}
