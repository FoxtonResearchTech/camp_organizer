class OnsiteProfileState {}

class OnsiteProfileInitial extends OnsiteProfileState {}

class OnsiteProfileLoading extends OnsiteProfileState {}

class OnsiteProfileLoaded extends OnsiteProfileState {
  final Map<String, dynamic> employee;
  OnsiteProfileLoaded(this.employee);
}

class OnsiteProfileError extends OnsiteProfileState {
  final String errorMessage;

  OnsiteProfileError(this.errorMessage);
}
