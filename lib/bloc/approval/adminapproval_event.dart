abstract class AdminApprovalEvent {}

class FetchDataEvents extends AdminApprovalEvent {
  FetchDataEvents();
}

class UpdateStatusEvent extends AdminApprovalEvent {
  final String documentId;

  UpdateStatusEvent(this.documentId);
}

class AddReasonEvent extends AdminApprovalEvent {
  final String reasonText;
  AddReasonEvent(this.reasonText);
}
