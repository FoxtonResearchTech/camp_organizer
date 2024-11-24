class AdminProfileState {}

class AdminProfileInitial extends AdminProfileState {}

class AdminProfileLoading extends AdminProfileState {}

class AdminProfileLoaded extends AdminProfileState {
  final Map<String, dynamic> employee;
  AdminProfileLoaded(this.employee);
}

class AdminProfileError extends AdminProfileState {
  final String errorMessage;

  AdminProfileError(this.errorMessage);
}
