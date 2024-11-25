import 'package:equatable/equatable.dart';

abstract class PatientFollowUpsState extends Equatable {
  const PatientFollowUpsState();

  @override
  List<Object?> get props => [];
}

class PatientFollowUpsInitial extends PatientFollowUpsState {}

class PatientFollowUpsLoading extends PatientFollowUpsState {}

class PatientFollowUpsSuccess extends PatientFollowUpsState {}

class PatientFollowUpsError extends PatientFollowUpsState {
  final String message;

  const PatientFollowUpsError({required this.message});

  @override
  List<Object?> get props => [message];
}
