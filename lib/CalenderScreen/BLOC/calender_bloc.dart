import 'package:flutter_bloc/flutter_bloc.dart';
import '../Repositry/calendar_repository.dart';
import 'calendar_state.dart';
import 'calender_event.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final CalendarRepository repository;

  CalendarBloc(this.repository) : super(CalendarInitial()) {
    on<FetchBookingsEvent>((event, emit) async {
      emit(CalendarLoading());
      try {
        final bookings = await repository.fetchBookings(event.serviceId, event.date);
        emit(CalendarLoaded(bookings));
      } catch (e) {
        emit(CalendarError(e.toString()));
      }
    });
  }
}
