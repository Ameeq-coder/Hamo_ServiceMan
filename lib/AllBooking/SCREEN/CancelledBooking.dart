import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../BLOC/all_bookings_bloc.dart';
import '../BLOC/all_bookings_state.dart';
import 'UpcomingBooking.dart';

class CancelledBookingsScreen extends StatefulWidget {
  const CancelledBookingsScreen({super.key});

  @override
  State<CancelledBookingsScreen> createState() => _CancelledBookingsScreenState();
}

class _CancelledBookingsScreenState extends State<CancelledBookingsScreen> {
  List<bool> isExpanded = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllBookingsBloc, AllBookingsState>(
      builder: (context, state) {
        if (state is AllBookingsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AllBookingsLoaded) {
          final cancelled = state.bookings
              .where((b) => b.status.toLowerCase() == "cancelled")
              .toList();

          if (isExpanded.length != cancelled.length) {
            isExpanded = List.generate(cancelled.length, (_) => false);
          }

          return _buildBookingList(context, cancelled, "Cancelled");
        } else if (state is AllBookingsError) {
          return const Center(child: Text('Error loading bookings'));
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildBookingList(BuildContext context, List bookings, String status) {
    if (bookings.isEmpty) {
      return Center(child: Text("No $status bookings."));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) => BookingCard(
        isOpen: isExpanded[index],
        onToggle: () => setState(() => isExpanded[index] = !isExpanded[index]),
        name: bookings[index].serviceType,
        person: bookings[index].serviceManName,
        dateTime: bookings[index].bookingDateTime.toString(),
        location: bookings[index].location,
        profileUrl: bookings[index].userImage, // ✅ FIXED: Use userImage instead of serviceman.detail.imageUrl
        status: status,
      ),
    );
  }
}