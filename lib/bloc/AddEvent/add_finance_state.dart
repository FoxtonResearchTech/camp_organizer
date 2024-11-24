import 'package:equatable/equatable.dart';

abstract class AddFinanceState extends Equatable {
  const AddFinanceState();

  @override
  List<Object?> get props => [];
}

class AddFinanceInitial extends AddFinanceState {}

class AddFinanceLoading extends AddFinanceState {}

class AddFinanceSuccess extends AddFinanceState {}

class AddFinanceError extends AddFinanceState {
  final String message;

  const AddFinanceError({required this.message});

  @override
  List<Object?> get props => [message];
}
