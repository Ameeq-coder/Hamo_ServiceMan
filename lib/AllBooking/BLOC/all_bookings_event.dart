import 'package:equatable/equatable.dart';

abstract class AllBookingsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchAllBookingsEvent extends AllBookingsEvent {
  final String servicemanId;

  FetchAllBookingsEvent(this.servicemanId);

  @override
  List<Object> get props => [servicemanId];
}
