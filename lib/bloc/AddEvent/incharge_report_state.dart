import 'package:equatable/equatable.dart';

abstract class InchargeReportState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InchargeReportInitial extends InchargeReportState {}

class InchargeReportLoading extends InchargeReportState {}

class InchargeReportLoaded extends InchargeReportState {
  final Map<String, dynamic> report; // The loaded incharge report data

  InchargeReportLoaded({required this.report});

  @override
  List<Object?> get props => [report];
}

class InchargeReportUpdated extends InchargeReportState {}

class InchargeReportError extends InchargeReportState {
  final String message;

  InchargeReportError({required this.message});

  @override
  List<Object?> get props => [message];
}
