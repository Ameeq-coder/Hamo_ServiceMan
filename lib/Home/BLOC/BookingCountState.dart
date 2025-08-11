import 'package:equatable/equatable.dart';
import '../MODELS/BookingCount.dart';

abstract class BookingCountState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BookingCountInitial extends BookingCountState {}

class BookingCountLoading extends BookingCountState {}

class BookingCountLoaded extends BookingCountState {
  final BookingCount bookingCount;

  BookingCountLoaded(this.bookingCount);

  @override
  List<Object?> get props => [bookingCount];
}

class BookingCountError extends BookingCountState {
  final String message;

  BookingCountError(this.message);

  @override
  List<Object?> get props => [message];
}
