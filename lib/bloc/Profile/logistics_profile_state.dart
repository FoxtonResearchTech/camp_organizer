class LogisticsProfileState {}

class LogisticsProfileInitial extends LogisticsProfileState {}

class LogisticsProfileLoading extends LogisticsProfileState {}

class LogisticsProfileLoaded extends LogisticsProfileState {
  final Map<String, dynamic> employee;
  LogisticsProfileLoaded(this.employee);
}

class LogisticsProfileError extends LogisticsProfileState {
  final String errorMessage;

  LogisticsProfileError(this.errorMessage);
}
