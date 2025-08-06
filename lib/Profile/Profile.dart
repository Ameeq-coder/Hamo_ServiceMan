import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../Common/BottomSheet.dart';
import 'REPO/ProfileRepo.dart';
import 'bloc/profile_bloc.dart';
import 'bloc/profile_event.dart';
import 'bloc/profile_state.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileBloc _profileBloc;
  final box = Hive.box('servicebox');

  @override
  void initState() {
    super.initState();
    _profileBloc = ProfileBloc(ProfileRepository());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final serviceManId = box.get('servicemanid');
      if (serviceManId != null) {
        _profileBloc.add(FetchProfileEvent(serviceManId));
      }
    });
  }

  @override
  void dispose() {
    _profileBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _profileBloc,
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is ProfileError) {
            return Scaffold(
              body: Center(child: Text("Error: ${state.message}")),
            );
          } else if (state is ProfileLoaded) {
            final profile = state.profile;

            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: const Text('Profile'),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 1,
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(profile.imageUrl),
                        backgroundColor: const Color(0xFFECECEC),
                      ),
                      const SizedBox(height: 20),
                      _buildInfoTile("Full Name", profile.name),
                      _buildInfoTile("Service Head", profile.serviceHead),
                      _buildInfoTile("Category", profile.category),
                      _buildInfoTile("Location", profile.location),
                      _buildInfoTile("Price", "Rs ${profile.price}"),
                      _buildInfoTile("About", profile.about),
                      const SizedBox(height: 30),
                      _buildLogoutButton(),
                    ],
                  ),
                ),
              ),
            );
          }

          return const SizedBox.shrink(); // For initial state
        },
      ),
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.grey[700], fontSize: 13)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // TODO: Add logout logic
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          backgroundColor: const Color(0xFF6C00FF),
          foregroundColor: Colors.white,
          elevation: 4,
        ),
        child: const Text("Log Out", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
