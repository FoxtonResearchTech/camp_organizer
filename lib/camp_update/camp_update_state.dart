abstract class CampUpdateState {}

class CampUpdateInitial extends CampUpdateState {}

class CampUpdateLoading extends CampUpdateState {}

class CampUpdateLoaded extends CampUpdateState {
  final List<Map<String, dynamic>> allCamps;
  CampUpdateLoaded(this.allCamps);
}

class CampUpdateError extends CampUpdateState {
  final String message;
  CampUpdateError(this.message);
}

class CampUpdateSuccess extends CampUpdateState {
  final String message;
  CampUpdateSuccess(this.message);
}
