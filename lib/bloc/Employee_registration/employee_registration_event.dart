// registration_event.dart
abstract class RegistrationEvent {}

class RegisterEmployeeEvent extends RegistrationEvent {
  final String firstName;
  final String lastName;
  final String dob;
  final String position;
  final String empCode;
  final String lane1;
  final String lane2;
  final String state;
  final String pinCode;
  final String password;
  final String reEnterPassword;
  final String? gender;

  RegisterEmployeeEvent({
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.position,
    required this.empCode,
    required this.lane1,
    required this.lane2,
    required this.state,
    required this.pinCode,
    required this.password,
    required this.reEnterPassword,
    this.gender,
  });
}
