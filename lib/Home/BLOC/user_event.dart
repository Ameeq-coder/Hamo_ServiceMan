import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchUsersByLocationEvent extends UserEvent {
  final String location;

  FetchUsersByLocationEvent(this.location);

  @override
  List<Object?> get props => [location];
}
