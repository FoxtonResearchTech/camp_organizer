// adminapproval_state.dart

abstract class AdminApprovalState {}

class AdminApprovalInitial extends AdminApprovalState {}

class AdminApprovalLoading extends AdminApprovalState {}

class AdminApprovalLoaded extends AdminApprovalState {
  final List<Map<String, dynamic>> allCamps;

  AdminApprovalLoaded(this.allCamps);
}

class AdminApprovalUpdated extends AdminApprovalState {}

class AdminApprovalError extends AdminApprovalState {
  final String message;

  AdminApprovalError(this.message);
}
