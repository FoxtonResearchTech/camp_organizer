import 'package:equatable/equatable.dart';

abstract class AddTeamState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddTeamInitial extends AddTeamState {}

class AddTeamLoading extends AddTeamState {}

class AddTeamSuccess extends AddTeamState {}

class AddTeamError extends AddTeamState {
  final String message;

  AddTeamError({required this.message});

  @override
  List<Object?> get props => [message];
}
