import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hamo_service_man/CalenderScreen/BLOC/calender_bloc.dart';
import 'package:hamo_service_man/Home/SCREENS/HomeScreen.dart';
import 'package:hive/hive.dart';

import '../AllBooking/BLOC/all_bookings_bloc.dart';
import '../AllBooking/REPO/AllBookingRepo.dart';
import '../AllBooking/SCREEN/MyBooking.dart';
import '../Auth/Repositry/login_repository.dart';
import '../CalenderScreen/CalenderScreen.dart';
import '../CalenderScreen/Repositry/calendar_repository.dart';
import '../Home/BLOC/BookingCountBloc.dart';
import '../Home/BLOC/BookingCountEvent.dart';
import '../Home/BLOC/invite_bloc.dart';
import '../Home/BLOC/servicemendetailbloc.dart';
import '../Home/BLOC/servicemendetailevent.dart';
import '../Home/BLOC/user_bloc.dart';
import '../Home/BLOC/user_event.dart';
import '../Home/REPO/HomeRepo.dart';
import '../Home/REPO/invite_repository.dart';
import '../Home/REPO/user_repository.dart';
import '../Profile/BLOC/profile_bloc.dart';
import '../Profile/Profile.dart';
import '../Profile/REPO/ProfileRepo.dart';

// Dummy Screens


class BottomNavigation extends StatelessWidget {
  final int currentIndex;

  const BottomNavigation({super.key, required this.currentIndex});

  Future<void> _onBottomNavItemTapped(int index, BuildContext context) async {
    final box = Hive.box('servicebox');
    final serviceManId = box.get('servicemanid');
    final location = box.get("location");

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => MultiBlocProvider(      providers: [
              BlocProvider(
                create: (_) =>
                BookingCountBloc(HomeRepo())..add(FetchBookingCountEvent(serviceManId)),
              ),
              BlocProvider(
                create: (_) =>
                ServiceManDetailsBloc(homeRepo: HomeRepo())..add(FetchServiceDetailEvent(serviceManId)),
              ),
              BlocProvider(
                create: (_) => UserBloc(UserRepository())..add(FetchUsersByLocationEvent(location)),
              ),
              BlocProvider(
                create: (_) => InviteBloc(InviteRepository()),
              ),
            ], child: HomeScreen()),
          ),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => AllBookingsBloc(AllBookingsRepository()),
              child: const MyBookingMain(),
            ),
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => CalendarBloc(CalendarRepository()),
              child:  CalendarScreen(),
            ),
          ),
        );
        break;
      case 3:
      // Get.to(() => UserFavorites());
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => ProfileBloc(ProfileRepository()),
              child:  ProfileScreen(),
            ),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.house),
          activeIcon: FaIcon(FontAwesomeIcons.houseChimney),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.receipt),
          label: 'Bookings',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.calendarDays),
          label: 'Calendar',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.commentDots),
          label: 'Inbox',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.user),
          label: 'Profile',
        ),
      ],
      selectedItemColor: Colors.deepPurple,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      onTap: (index) => _onBottomNavItemTapped(index, context),
    );
  }
}
