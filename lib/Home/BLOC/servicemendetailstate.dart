import 'package:equatable/equatable.dart';
import '../MODELS/ServiceDetail.dart';

abstract class ServiceDetailsState extends Equatable {
  const ServiceDetailsState();

  @override
  List<Object?> get props => [];
}

class ServiceDetailInitial extends ServiceDetailsState {}

class ServiceDetailLoading extends ServiceDetailsState {}

class ServiceDetailLoaded extends ServiceDetailsState {
  final ServiceDetails serviceDetail;

  const ServiceDetailLoaded(this.serviceDetail);

  @override
  List<Object?> get props => [serviceDetail];
}

class ServiceDetailError extends ServiceDetailsState {
  final String message;

  const ServiceDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
