abstract class OnsiteApprovalState {}

class OnsiteApprovalInitial extends OnsiteApprovalState {}

class OnsiteApprovalLoading extends OnsiteApprovalState {}

class OnsiteApprovalLoaded extends OnsiteApprovalState {
  final List<Map<String, dynamic>> approvals;

  OnsiteApprovalLoaded(this.approvals);
}

class OnsiteApprovalError extends OnsiteApprovalState {
  final String errorMessage;

  OnsiteApprovalError(this.errorMessage);
}

class OnsiteApprovalUpdated extends OnsiteApprovalState {}