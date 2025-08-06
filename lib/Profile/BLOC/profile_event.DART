import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchProfileEvent extends ProfileEvent {
  final String servicemanId;

  FetchProfileEvent(this.servicemanId);

  @override
  List<Object> get props => [servicemanId];
}
