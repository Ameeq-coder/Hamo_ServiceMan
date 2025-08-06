import 'package:equatable/equatable.dart';

abstract class SignupState extends Equatable {
  @override
  List<Object> get props => [];
}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {
  final String id;
  final String email;

  SignupSuccess({required this.id, required this.email});

  @override
  List<Object> get props => [id, email];
}

class SignupFailure extends SignupState {
  final String error;

  SignupFailure({required this.error});

  @override
  List<Object> get props => [error];
}
