import 'package:equatable/equatable.dart';

import '../MODEL/AllBoookingModel.dart';

abstract class AllBookingsState extends Equatable {
  @override
  List<Object> get props => [];
}

class AllBookingsInitial extends AllBookingsState {}

class AllBookingsLoading extends AllBookingsState {}

class AllBookingsLoaded extends AllBookingsState {
  final List<AllBooking> bookings;

  AllBookingsLoaded(this.bookings);

  @override
  List<Object> get props => [bookings];
}

class AllBookingsError extends AllBookingsState {
  final String message;

  AllBookingsError(this.message);

  @override
  List<Object> get props => [message];
}
