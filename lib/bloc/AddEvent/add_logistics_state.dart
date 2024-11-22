import 'package:equatable/equatable.dart';

abstract class AddLogisticsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddLogisticsInitial extends AddLogisticsState {}

class AddLogisticsLoading extends AddLogisticsState {}

class AddLogisticsSuccess extends AddLogisticsState {}

class AddLogisticsError extends AddLogisticsState {
  final String message;

  AddLogisticsError({required this.message});

  @override
  List<Object?> get props => [message];
}
