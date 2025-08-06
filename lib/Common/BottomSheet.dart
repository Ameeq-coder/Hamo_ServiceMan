// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//
// // Dummy Screens
//
//
// class BottomNavigation extends StatelessWidget {
//   final int currentIndex;
//
//   const BottomNavigation({super.key, required this.currentIndex});
//
//   // Future<void> _onBottomNavItemTapped(int index, BuildContext context) async {
//   //   switch (index) {
//   //     case 0:
//   //       Navigator.pushReplacement(
//   //         context,
//   //         MaterialPageRoute(
//   //           builder: (_) => BlocProvider(
//   //             create: (_) => LoginBloc(AuthRepository()),
//   //             child: const Home(),
//   //           ),
//   //         ),
//   //       );
//   //       break;
//   //     case 1:
//   //       Navigator.pushReplacement(
//   //         context,
//   //         MaterialPageRoute(
//   //           builder: (_) => BlocProvider(
//   //             create: (_) => LoginBloc(AuthRepository()),
//   //             child: const MyBookingMain(),
//   //           ),
//   //         ),
//   //       );
//   //       break;
//   //     case 2:
//   //       Navigator.pushReplacement(
//   //         context,
//   //         MaterialPageRoute(
//   //           builder: (_) => BlocProvider(
//   //             create: (_) => CalendarBookingBloc(CalendarBookingRepository()),
//   //             child:  CalendarScreen(),
//   //           ),
//   //         ),
//   //       );
//   //       break;
//   //     case 3:
//   //     // Get.to(() => UserFavorites());
//   //       break;
//   //     case 4:
//   //       Navigator.pushReplacement(
//   //         context,
//   //         MaterialPageRoute(
//   //           builder: (_) => BlocProvider(
//   //             create: (_) => ProfileBloc(ProfileRepository()),
//   //             child:  ProfileScreen(),
//   //           ),
//   //         ),
//   //       );
//   //       break;
//   //   }
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       currentIndex: currentIndex,
//       items: const <BottomNavigationBarItem>[
//         BottomNavigationBarItem(
//           icon: FaIcon(FontAwesomeIcons.house),
//           activeIcon: FaIcon(FontAwesomeIcons.houseChimney),
//           label: 'Home',
//         ),
//         BottomNavigationBarItem(
//           icon: FaIcon(FontAwesomeIcons.receipt),
//           label: 'Bookings',
//         ),
//         BottomNavigationBarItem(
//           icon: FaIcon(FontAwesomeIcons.calendarDays),
//           label: 'Calendar',
//         ),
//         BottomNavigationBarItem(
//           icon: FaIcon(FontAwesomeIcons.commentDots),
//           label: 'Inbox',
//         ),
//         BottomNavigationBarItem(
//           icon: FaIcon(FontAwesomeIcons.user),
//           label: 'Profile',
//         ),
//       ],
//       selectedItemColor: Colors.deepPurple,
//       unselectedItemColor: Colors.grey,
//       showSelectedLabels: false,
//       showUnselectedLabels: false,
//       type: BottomNavigationBarType.fixed,
//       onTap: (index) => _onBottomNavItemTapped(index, context),
//     );
//   }
// }
