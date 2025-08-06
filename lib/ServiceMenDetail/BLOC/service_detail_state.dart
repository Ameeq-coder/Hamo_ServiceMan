import 'package:equatable/equatable.dart';

abstract class ServiceDetailState extends Equatable {
  @override
  List<Object> get props => [];
}

class ServiceDetailInitial extends ServiceDetailState {}

class ServiceDetailLoading extends ServiceDetailState {}

class ServiceDetailSuccess extends ServiceDetailState {
  final Map<String, dynamic> response;

  ServiceDetailSuccess(this.response);

  @override
  List<Object> get props => [response];
}

class ServiceDetailFailure extends ServiceDetailState {
  final String error;

  ServiceDetailFailure(this.error);

  @override
  List<Object> get props => [error];
}
