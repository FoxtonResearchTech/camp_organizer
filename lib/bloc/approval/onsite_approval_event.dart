abstract class OnsiteApprovalEvent {}

class FetchOnsiteApprovalData extends OnsiteApprovalEvent {
  FetchOnsiteApprovalData();
}

class UpdateStatusEvent extends OnsiteApprovalEvent {
  final String documentId;

  UpdateStatusEvent(this.documentId);
}