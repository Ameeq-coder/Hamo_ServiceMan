import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SignupSubmitted extends SignupEvent {
  final String email;
  final String password;
  final String serviceType;

  SignupSubmitted({
    required this.email,
    required this.password,
    required this.serviceType,
  });

  @override
  List<Object> get props => [email, password, serviceType];
}
