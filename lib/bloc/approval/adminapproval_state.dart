abstract class AdminApprovalState {}

class AdminApprovalInitial extends AdminApprovalState {}

class AdminApprovalLoading extends AdminApprovalState {}

class AdminApprovalLoaded extends AdminApprovalState {
  final List<Map<String, dynamic>> camps;

  AdminApprovalLoaded(this.camps);
}

class AdminApprovalError extends AdminApprovalState {
  final String errorMessage;

  AdminApprovalError(this.errorMessage);
}
