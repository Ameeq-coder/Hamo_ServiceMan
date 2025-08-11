import 'package:equatable/equatable.dart';

abstract class BookingCountEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchBookingCountEvent extends BookingCountEvent {
  final String serviceManId;

  FetchBookingCountEvent(this.serviceManId);

  @override
  List<Object?> get props => [serviceManId];
}
