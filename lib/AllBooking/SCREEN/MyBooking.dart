import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../../Common/BottomSheet.dart';


// ✅ Import your screens

import '../BLOC/all_bookings_bloc.dart';
import '../BLOC/all_bookings_event.dart';
import '../REPO/AllBookingRepo.dart';
import 'CancelledBooking.dart';
import 'CompletedScreen.dart';
import 'UpcomingBooking.dart';

class MyBookingMain extends StatelessWidget {
  const MyBookingMain({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('servicebox');
    final serviceManId = box.get('servicemanid');

    return BlocProvider(
      create: (_) => AllBookingsBloc(AllBookingsRepository())..add(FetchAllBookingsEvent(serviceManId)),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "My Bookings",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Row(
                        children: const [
                          Icon(Icons.search, color: Colors.black),
                          SizedBox(width: 16),
                          Icon(Icons.more_vert, color: Colors.black),
                        ],
                      )
                    ],
                  ),
                ),
                const TabBar(
                  labelColor: Colors.purple,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.purple,
                  tabs: [
                    Tab(text: "Upcoming"),
                    Tab(text: "Completed"),
                    Tab(text: "Cancelled"),
                  ],
                ),
                const Expanded(
                  child: TabBarView(
                    children: [
                      UpcomingBookingsScreen(),
                      CompletedBookingsScreen(),
                      CancelledBookingsScreen(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // bottomNavigationBar: BottomNavigation(currentIndex: 0),
        ),
      ),
    );
  }
}
