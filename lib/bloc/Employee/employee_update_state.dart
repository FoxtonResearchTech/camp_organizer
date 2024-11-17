class EmployeeUpdateState {}

class EmployeeUpdateInitial extends EmployeeUpdateState {}

class EmployeeUpdateLoading extends EmployeeUpdateState {}

class EmployeeUpdateLoaded extends EmployeeUpdateState {
  final List<Map<String, dynamic>> employeesData;

  EmployeeUpdateLoaded(this.employeesData);
}

class EmployeeUpdateError extends EmployeeUpdateState {
  final String errorMessage;

  EmployeeUpdateError(this.errorMessage);
}
