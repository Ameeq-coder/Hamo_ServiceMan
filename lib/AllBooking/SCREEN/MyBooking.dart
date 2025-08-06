// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../Common/BottomSheet.dart';
//
// import '../BLOC/all_bookings_bloc.dart';
// import '../repo/AllBookingRepo.dart';
//
// import 'package:hive/hive.dart';
//
// class MyBookingMain extends StatelessWidget {
//   const MyBookingMain({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final userId = Hive.box('userBox').get('userId'); // or your correct box key
//
//     return BlocProvider(
//       create: (_) => AllBookingsBloc(AllBookingsRepository())..add(FetchAllBookings(userId)),
//       child: DefaultTabController(
//         length: 3,
//         child: Scaffold(
//           backgroundColor: Colors.white,
//           body: SafeArea(
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         "My Bookings",
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                       Row(
//                         children: const [
//                           Icon(Icons.search, color: Colors.black),
//                           SizedBox(width: 16),
//                           Icon(Icons.more_vert, color: Colors.black),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//                 const TabBar(
//                   labelColor: Colors.purple,
//                   unselectedLabelColor: Colors.grey,
//                   indicatorColor: Colors.purple,
//                   tabs: [
//                     Tab(text: "Upcoming"),
//                     Tab(text: "Completed"),
//                     Tab(text: "Cancelled"),
//                   ],
//                 ),
//                 const Expanded(
//                   child: TabBarView(
//                     children: [
//                       UpcomingScreen(),
//                       CompletedScreen(),
//                       CancelledScreen(),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           bottomNavigationBar: BottomNavigation(currentIndex: 0),
//         ),
//       ),
//     );
//   }
// }
