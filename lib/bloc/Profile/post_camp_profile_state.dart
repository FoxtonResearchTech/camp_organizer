class PostCampProfileState {}

class PostCampProfileInitial extends PostCampProfileState {}

class PostCampProfileLoading extends PostCampProfileState {}

class PostCampProfileLoaded extends PostCampProfileState {
  final Map<String, dynamic> employee;
  PostCampProfileLoaded(this.employee);
}

class PostCampProfileError extends PostCampProfileState {
  final String errorMessage;

  PostCampProfileError(this.errorMessage);
}
