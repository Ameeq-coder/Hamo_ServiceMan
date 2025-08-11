import 'package:flutter_bloc/flutter_bloc.dart';
import '../REPO/HomeRepo.dart';
import 'BookingCountEvent.dart';
import 'BookingCountState.dart';


class BookingCountBloc extends Bloc<BookingCountEvent, BookingCountState> {
  final HomeRepo repository;

  BookingCountBloc(this.repository) : super(BookingCountInitial()) {
    on<FetchBookingCountEvent>((event, emit) async {
      emit(BookingCountLoading());
      try {
        final bookingCount =
        await repository.fetchBookingCounts(event.serviceManId);
        emit(BookingCountLoaded(bookingCount));
      } catch (e) {
        emit(BookingCountError(e.toString()));
      }
    });
  }
}
