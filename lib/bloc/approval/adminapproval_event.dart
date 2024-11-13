abstract class AdminApprovalEvent {}

class FetchDataEvents extends AdminApprovalEvent {
  FetchDataEvents();
}

class UpdateStatusEvent extends AdminApprovalEvent {
  final String documentId;

  UpdateStatusEvent(this.documentId);
}
