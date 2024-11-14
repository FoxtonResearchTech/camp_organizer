class StatusState {}

class StatusInitial extends StatusState {}

class StatusLoading extends StatusState {}

class StatusLoaded extends StatusState {
  final List<Map<String, dynamic>> employees;
  final String employeeDocId;
  final String campDocId;

  StatusLoaded(this.employees, this.employeeDocId, this.campDocId);
}

class StatusError extends StatusState {
  final String errorMessage;

  StatusError(this.errorMessage);
}
