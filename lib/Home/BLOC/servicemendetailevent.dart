import 'package:equatable/equatable.dart';

abstract class ServiceDetailsEvent extends Equatable {
  const ServiceDetailsEvent();

  @override
  List<Object> get props => [];
}

class FetchServiceDetailEvent extends ServiceDetailsEvent {
  final String serviceManId;

  const FetchServiceDetailEvent(this.serviceManId);

  @override
  List<Object> get props => [serviceManId];
}
