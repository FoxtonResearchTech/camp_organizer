abstract class EmployeeUpdateEvent {}

class FetchDataEvent extends EmployeeUpdateEvent {}

class DeleteEmployeeEvent extends EmployeeUpdateEvent {
  final String empCode;

  DeleteEmployeeEvent(this.empCode);
}
