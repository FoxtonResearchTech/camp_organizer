class StatusState {}

class StatusInitial extends StatusState {}

class StatusLoading extends StatusState {}

class StatusLoaded extends StatusState {
  final List<Map<String, dynamic>> employees;
  StatusLoaded(this.employees);
}

class StatusError extends StatusState {
  final String errorMessage;

  StatusError(this.errorMessage);
}
