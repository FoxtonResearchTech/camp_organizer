class CampInChargeProfileState {}

class CampInChargeProfileInitial extends CampInChargeProfileState {}

class CampInChargeProfileLoading extends CampInChargeProfileState {}

class CampInChargeProfileLoaded extends CampInChargeProfileState {
  final Map<String, dynamic> employee;
  CampInChargeProfileLoaded(this.employee);
}

class CampInChargeProfileError extends CampInChargeProfileState {
  final String errorMessage;

  CampInChargeProfileError(this.errorMessage);
}
