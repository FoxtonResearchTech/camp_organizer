abstract class AdminApprovalState {}

class AdminApprovalInitial extends AdminApprovalState {}

class AdminApprovalLoading extends AdminApprovalState {}

class AdminApprovalLoaded extends AdminApprovalState {
  final List<Map<String, dynamic>> allCamps;
  final List<String> employeeDocId; // Employee document ID
  final List<String> campDocIds; // List of camp document IDs

  AdminApprovalLoaded(this.allCamps, this.employeeDocId, this.campDocIds);
}

class AdminApprovalUpdated extends AdminApprovalState {}

class AdminApprovalError extends AdminApprovalState {
  final String message;

  AdminApprovalError(this.message);
}
