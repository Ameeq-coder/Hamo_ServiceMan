import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hamo_service_man/Home/BLOC/servicemendetailbloc.dart';
import 'package:hamo_service_man/Home/BLOC/servicemendetailevent.dart';
import 'package:hamo_service_man/Home/BLOC/servicemendetailstate.dart';
import 'package:hive/hive.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../Common/BottomSheet.dart';
import '../../ServiceMenDetail/BLOC/service_detail_bloc.dart';

import '../BLOC/BookingCountBloc.dart';
import '../BLOC/BookingCountEvent.dart';
import '../BLOC/BookingCountState.dart';
import '../BLOC/user_bloc.dart';
import '../BLOC/user_event.dart';
import '../BLOC/user_state.dart';
import '../BLOC/invite_bloc.dart';
import '../BLOC/invite_event.dart';
import '../BLOC/invite_state.dart';
import '../REPO/HomeRepo.dart';
import '../REPO/user_repository.dart';
import '../REPO/invite_repository.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('servicebox');
    final serviceManId = box.get('servicemanid');
    final location = box.get("location");

    return MultiBlocProvider(
      providers: [
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
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocListener<InviteBloc, InviteState>(
          listener: (context, inviteState) {
            if (inviteState is InviteSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(inviteState.response.message),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
            } else if (inviteState is InviteFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to send invite: ${inviteState.error}'),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          },
          child: BlocBuilder<ServiceManDetailsBloc, ServiceDetailsState>(
            builder: (context, serviceState) {
              if (serviceState is ServiceDetailLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (serviceState is ServiceDetailError) {
                return Center(child: Text("Error: ${serviceState.message}"));
              } else if (serviceState is ServiceDetailLoaded) {
                final detail = serviceState.serviceDetail;

                return BlocBuilder<BookingCountBloc, BookingCountState>(
                  builder: (context, bookingState) {
                    if (bookingState is BookingCountLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (bookingState is BookingCountError) {
                      return Center(child: Text("Error: ${bookingState.message}"));
                    } else if (bookingState is BookingCountLoaded) {
                      final data = bookingState.bookingCount;

                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            // ---------- Service Detail Header ----------
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 22,
                                        backgroundImage: detail.imageUrl.isNotEmpty
                                            ? NetworkImage(detail.imageUrl)
                                            : const NetworkImage("https://randomuser.me/api/portraits/men/75.jpg"),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('Welcome 👋',
                                              style: TextStyle(fontSize: 12, color: Colors.grey)),
                                          Text(detail.name,
                                              style: const TextStyle(
                                                  fontSize: 16, fontWeight: FontWeight.bold)),
                                        ],
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(FontAwesomeIcons.locationPin),
                                        onPressed: () {},
                                      ),
                                      Text(detail.location,
                                          style: const TextStyle(
                                              fontSize: 16, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // ---------- Booking Count Cards ----------
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    InfoCard(
                                      title: "Total Bookings",
                                      amount: data.total.toString(),
                                      backgroundColor: const Color(0xFFFFF5D9),
                                    ),
                                    const SizedBox(width: 15),
                                    InfoCard(
                                      title: "Completed Booking",
                                      amount: data.completed.toString(),
                                      backgroundColor: const Color(0xFFE7EDFF),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    InfoCard(
                                      title: "Cancel Bookings",
                                      amount: data.cancelled.toString(),
                                      backgroundColor: const Color(0xFFFFE0EB),
                                    ),
                                    const SizedBox(width: 15),
                                    InfoCard(
                                      title: "Upcoming Booking",
                                      amount: data.upcoming.toString(),
                                      backgroundColor: const Color(0xFFDCFAF8),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: 20,),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    'Users Near Me',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  // Text(
                                  //   'See All',
                                  //   style: TextStyle(fontSize: 14, color: Colors.deepPurple, fontWeight: FontWeight.w600),
                                  // ),
                                ],
                              ),
                            ),

                            BlocBuilder<UserBloc, UserState>(
                              builder: (context, userState) {
                                if (userState is UserLoading) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (userState is UserLoaded) {
                                  final users = userState.users;

                                  return Column(
                                    children: [
                                      ListView.builder(
                                        itemCount: users.length,
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        itemBuilder: (context, index) {
                                          final user = users[index];
                                          return Container(
                                            margin: const EdgeInsets.only(bottom: 16),
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(16),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.05),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(12),
                                                  child: Image.network(
                                                    user.imageUrl,
                                                    width: 64,
                                                    height: 64,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        user.name,
                                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                                      ),
                                                      Text(
                                                        user.address,
                                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // BlocBuilder<InviteBloc, InviteState>(
                                                //   builder: (context, inviteState) {
                                                //     bool isLoading = inviteState is InviteLoading;
                                                //
                                                //     return ElevatedButton(
                                                //       onPressed: isLoading ? null : () {
                                                //         final box = Hive.box('servicebox');
                                                //         final currentServiceManId = box.get('servicemanid');
                                                //
                                                //         if (currentServiceManId != null) {
                                                //           context.read<InviteBloc>().add(
                                                //             SendInviteEvent(
                                                //               servicemanId: currentServiceManId.toString(),
                                                //               userId: user.userId.toString(), // Assuming user has an id field
                                                //             ),
                                                //           );
                                                //         }
                                                //         print(currentServiceManId);
                                                //         print(user.userId.toString());
                                                //       },
                                                //       style: ElevatedButton.styleFrom(
                                                //         backgroundColor: isLoading ? Colors.grey : Colors.deepPurple,
                                                //         shape: RoundedRectangleBorder(
                                                //           borderRadius: BorderRadius.circular(12),
                                                //         ),
                                                //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                                //       ),
                                                //       child: isLoading
                                                //           ? const SizedBox(
                                                //         width: 16,
                                                //         height: 16,
                                                //         child: CircularProgressIndicator(
                                                //           strokeWidth: 2,
                                                //           valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                //         ),
                                                //       )
                                                //           : const Text('Invite', style: TextStyle(color: Colors.white)),
                                                //     );
                                                //   },
                                                // ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                } else if (userState is UserError) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Text("Error loading users: ${userState.message}"),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
        bottomNavigationBar: BottomNavigation(currentIndex: 0),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String amount;
  final Color backgroundColor;

  const InfoCard({
    Key? key,
    required this.title,
    required this.amount,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: 195,
      height: screenHeight * 0.18,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 3),
            blurRadius: 5,
          ),
        ],
      ),
      padding: const EdgeInsets.all(12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
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