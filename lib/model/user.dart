// models/user_model.dart

class UserModel {
  final String firstName;
  final String lastName;
  final String dob;
  final String gender;
  final String position;
  final String empCode;
  final String lane1;
  final String lane2;
  final String state;
  final String pincode;
  final String uid;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.gender,
    required this.position,
    required this.empCode,
    required this.lane1,
    required this.lane2,
    required this.state,
    required this.pincode,
    required this.uid,
  });

  // Convert a UserModel into a Map
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'dob': dob,
      'gender': gender,
      'position': position,
      'empCode': empCode,
      'lane1': lane1,
      'lane2': lane2,
      'state': state,
      'pincode': pincode,
      'uid': uid,
    };
  }

  // Create a UserModel from a Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      firstName: map['firstName'],
      lastName: map['lastName'],
      dob: map['dob'],
      gender: map['gender'],
      position: map['position'],
      empCode: map['empCode'],
      lane1: map['lane1'],
      lane2: map['lane2'],
      state: map['state'],
      pincode: map['pincode'],
      uid: map['uid'],
    );
  }
}
