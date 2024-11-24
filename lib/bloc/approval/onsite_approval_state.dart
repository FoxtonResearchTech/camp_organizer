abstract class OnsiteApprovalState {}

class OnsiteApprovalInitial extends OnsiteApprovalState {}

class OnsiteApprovalLoading extends OnsiteApprovalState {}

class OnsiteApprovalLoaded extends OnsiteApprovalState {
  final List<Map<String, dynamic>> allCamps;
  final List<String> employeeDocId; // Employee document ID
  final List<String> campDocIds; // List of camp document IDs

  OnsiteApprovalLoaded(this.allCamps, this.employeeDocId, this.campDocIds);
}

class OnsiteApprovalError extends OnsiteApprovalState {
  final String errorMessage;

  OnsiteApprovalError(this.errorMessage);
}

class OnsiteApprovalUpdated extends OnsiteApprovalState {}