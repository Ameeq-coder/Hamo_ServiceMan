import 'package:equatable/equatable.dart';

abstract class CalendarEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchBookingsEvent extends CalendarEvent {
  final String serviceId;
  final String date;

  FetchBookingsEvent({required this.serviceId, required this.date});

  @override
  List<Object> get props => [serviceId, date];
}
