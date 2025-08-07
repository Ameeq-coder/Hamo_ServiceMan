import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../BLOC/all_bookings_bloc.dart';
import '../BLOC/all_bookings_state.dart';

class UpcomingBookingsScreen extends StatefulWidget {
  const UpcomingBookingsScreen({super.key});

  @override
  State<UpcomingBookingsScreen> createState() => _UpcomingBookingsScreenState();
}

class _UpcomingBookingsScreenState extends State<UpcomingBookingsScreen> {
  List<bool> isExpanded = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllBookingsBloc, AllBookingsState>(
      builder: (context, state) {
        if (state is AllBookingsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AllBookingsLoaded) {
          final upcoming = state.bookings.where((b) => b.status == "upcoming").toList();
          if (isExpanded.length != upcoming.length) {
            isExpanded = List.generate(upcoming.length, (_) => false);
          }

          return _buildBookingList(context, upcoming, "Upcoming");
        } else if (state is AllBookingsError) {
          return const Center(child: Text('Error loading bookings'));
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildBookingList(BuildContext context, List bookings, String status) {
    if (bookings.isEmpty) {
      return const Center(child: Text("No bookings."));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) => BookingCard(
        isOpen: isExpanded[index],
        onToggle: () => setState(() => isExpanded[index] = !isExpanded[index]),
        name: bookings[index].serviceType,
        person: bookings[index].serviceManName, // ✅ This is correct
        dateTime: bookings[index].bookingDateTime.toString(),
        location: bookings[index].location,
        profileUrl: bookings[index].userImage, // ✅ FIXED: Use userImage instead of serviceman.detail.imageUrl
        status: status,
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onToggle;
  final String name;
  final String person;
  final String dateTime;
  final String location;
  final String profileUrl;
  final String status;

  const BookingCard({
    super.key,
    required this.isOpen,
    required this.onToggle,
    required this.name,
    required this.person,
    required this.dateTime,
    required this.location,
    required this.profileUrl,
    required this.status,
  });

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "upcoming":
        return Colors.purple;
      case "completed":
        return Colors.green;
      case "cancelled":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(radius: 28, backgroundImage: NetworkImage(profileUrl)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(person, style: const TextStyle(fontSize: 12)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: getStatusColor(status).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(status,
                          style: TextStyle(color: getStatusColor(status), fontSize: 11)),
                    )
                  ],
                ),
              ),
            ],
          ),
          if (isOpen) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.black54),
                const SizedBox(width: 8),
                Expanded(child: Text(dateTime, style: const TextStyle(fontSize: 13))),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.black54),
                const SizedBox(width: 8),
                Expanded(child: Text(location, style: const TextStyle(fontSize: 13))),
              ],
            ),
          ],
          const SizedBox(height: 12),
          Center(
            child: IconButton(
              icon: Icon(isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
              onPressed: onToggle,
            ),
          )
        ],
      ),
    );
  }
}