import 'package:flutter_bloc/flutter_bloc.dart';
import '../REPO/AllBookingRepo.dart';
import 'all_bookings_event.dart';
import 'all_bookings_state.dart';

class AllBookingsBloc extends Bloc<AllBookingsEvent, AllBookingsState> {
  final AllBookingsRepository repository;

  AllBookingsBloc(this.repository) : super(AllBookingsInitial()) {
    on<FetchAllBookingsEvent>((event, emit) async {
      emit(AllBookingsLoading());
      try {
        final bookings = await repository.fetchAllBookings(event.servicemanId);
        emit(AllBookingsLoaded(bookings));
      } catch (e) {
        emit(AllBookingsError(e.toString()));
      }
    });
  }
}
