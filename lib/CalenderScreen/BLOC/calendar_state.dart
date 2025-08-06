import 'package:equatable/equatable.dart';
import '../Model/calendar_model.dart';

abstract class CalendarState extends Equatable {
  @override
  List<Object> get props => [];
}

class CalendarInitial extends CalendarState {}

class CalendarLoading extends CalendarState {}

class CalendarLoaded extends CalendarState {
  final List<Booking> bookings;

  CalendarLoaded(this.bookings);

  @override
  List<Object> get props => [bookings];
}

class CalendarError extends CalendarState {
  final String message;

  CalendarError(this.message);

  @override
  List<Object> get props => [message];
}
