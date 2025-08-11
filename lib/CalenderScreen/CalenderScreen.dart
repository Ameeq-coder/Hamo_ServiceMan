import 'package:flutter/material.dart';
import 'package:hamo_service_man/CalenderScreen/BLOC/calendar_state.dart';
import 'package:hamo_service_man/CalenderScreen/BLOC/calender_event.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Common/BottomSheet.dart';
import 'BLOC/calender_bloc.dart';
import 'Model/calendar_model.dart';


class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDate = DateTime.now();
  List<Map<String, String>> selectedBookings = [];

  @override
  void initState() {
    super.initState();
    _fetchBookingsForDate(selectedDate);
  }

  void _fetchBookingsForDate(DateTime date) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final box = Hive.box('servicebox');
    final serviceManId = box.get('servicemanid');
    BlocProvider.of<CalendarBloc>(context).add(
      FetchBookingsEvent(serviceId: serviceManId, date: formattedDate),
    );
  }

  void onDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
    });
    _fetchBookingsForDate(date);
  }

  void _mapToUI(List<Booking> bookings) {
    selectedBookings = bookings
        .where((b) => b.status.toLowerCase() == 'upcoming')
        .map((b) => {
      'title': b.serviceType,
      'name': b.serviceManName,
      'status': b.status,
      'image': b.userImage
    })
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CalendarBloc, CalendarState>(
      listener: (context, state) {
        if (state is CalendarLoaded) {
          _mapToUI(state.bookings);
        } else if (state is CalendarError) {
          selectedBookings = [];
          setState(() {});
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            "My Calendar",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: const [Icon(Icons.more_vert, color: Colors.black)],
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF2E9FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    DateFormat.yMMMM().format(selectedDate),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  CalendarDatePicker(
                    initialDate: selectedDate,
                    firstDate: DateTime(2024, 1),
                    lastDate: DateTime(2025, 12),
                    onDateChanged: onDateSelected,
                  )
                ],
              ),
            ),
            Expanded(
              child: selectedBookings.isEmpty
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/EmptyBooking.PNG',
                    height: 140,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "You have no service booking",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "You don't have a service booking on this date",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              )
                  : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Service Booking (${selectedBookings.length})",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          "See All",
                          style: TextStyle(
                            color: Colors.purple,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: selectedBookings.length,
                      itemBuilder: (context, index) {
                        final booking = selectedBookings[index];
                        final servicemanImageUrl = booking['image'];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F7F7),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  servicemanImageUrl!,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/images/NoBooking.PNG',
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      booking['title']!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      booking['name']!,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE9D7FF),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        booking['status']!,
                                        style: const TextStyle(
                                          color: Colors.purple,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.more_vert, color: Colors.grey.shade700),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
        bottomNavigationBar: BottomNavigation(currentIndex: 2),
      ),
    );
  }
}