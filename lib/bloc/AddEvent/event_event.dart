abstract class EventEvent {}

class SubmitForm extends EventEvent {
  final String campName;
  final String organization;
  final String address;
  final String city;
  final String state;
  final String pincode;
  final String name;
  final String phoneNumber1;
  final String phoneNumber2;
  final String name2;
  final String phoneNumber1_2;
  final String phoneNumber2_2;
  final String totalSquareFeet;
  final String noOfPatientExpected;

  SubmitForm({
    required this.campName,
    required this.organization,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    required this.name,
    required this.phoneNumber1,
    required this.phoneNumber2,
    required this.name2,
    required this.phoneNumber1_2,
    required this.phoneNumber2_2,
    required this.totalSquareFeet,
    required this.noOfPatientExpected,
  });
}
