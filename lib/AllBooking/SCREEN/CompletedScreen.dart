import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../BLOC/all_bookings_bloc.dart';
import '../BLOC/all_bookings_state.dart';
import 'UpcomingBooking.dart';

class CompletedBookingsScreen extends StatefulWidget {
  const CompletedBookingsScreen({super.key});

  @override
  State<CompletedBookingsScreen> createState() => _CompletedBookingsScreenState();
}

class _CompletedBookingsScreenState extends State<CompletedBookingsScreen> {
  List<bool> isExpanded = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllBookingsBloc, AllBookingsState>(
      builder: (context, state) {
        if (state is AllBookingsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AllBookingsLoaded) {
          final completed = state.bookings.where((b) => b.status.toLowerCase() == "completed").toList();

          if (isExpanded.length != completed.length) {
            isExpanded = List.generate(completed.length, (_) => false);
          }

          return _buildBookingList(context, completed, "Completed");
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



class InfoCard extends StatelessWidget {
  final String title;
  final String amount;
  final String imagePath;
  final Color backgroundColor;

  const InfoCard({
    Key? key,
    required this.title,
    required this.amount,
    required this.imagePath,
    required this.backgroundColor, // Default light yellow color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen height
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: 195, // Fixed width
      height: screenHeight * 0.18, // Adjust height based on screen height (e.g. 15% of screen height)
      decoration: BoxDecoration(
        color: Colors.white, // White background
        borderRadius: BorderRadius.circular(18), // Rounded corners
        border: Border.all(
          color: Colors.grey.shade300, // Light grey border
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Subtle shadow
            offset: const Offset(0, 3),
            blurRadius: 5,
          ),
        ],
      ),
      padding: const EdgeInsets.all(12.0), // Adjusted padding
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // Center elements vertically
        children: [
          // Image Icon Container
          Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(10),
            child: Image.asset(
              imagePath,
              height: 24,
              width: 24,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 12),
          // Text Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center, // Center text vertically
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}