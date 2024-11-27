class FinanceProfileState {}

class FinanceProfileInitial extends FinanceProfileState {}

class FinanceProfileLoading extends FinanceProfileState {}

class FinanceProfileLoaded extends FinanceProfileState {
  final Map<String, dynamic> employee;
  FinanceProfileLoaded(this.employee);
}

class FinanceProfileError extends FinanceProfileState {
  final String errorMessage;

  FinanceProfileError(this.errorMessage);
}
