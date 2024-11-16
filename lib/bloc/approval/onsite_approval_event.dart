abstract class OnsiteApprovalEvent {}

class FetchDataEvents extends OnsiteApprovalEvent {
  FetchDataEvents();
}

class UpdateStatusEvent extends OnsiteApprovalEvent {
  final String documentId;

  UpdateStatusEvent(this.documentId);
}