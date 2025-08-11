import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../MODELS/user_detail_model.dart';
import '../MODELS/BookingCount.dart';
import '../MODELS/ServiceDetail.dart';

class HomeRepo {
  Future<BookingCount> fetchBookingCounts(String serviceManId) async {
    final url = Uri.parse(
        'https://hamo-backend.vercel.app/api/v1/booking/count/all/$serviceManId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return BookingCount.fromJson(data);
    } else {
      throw Exception('Failed to load booking counts');
    }
  }

  Future<ServiceDetails> fetchServiceDetails(String serviceManId) async {
    final url = Uri.parse(
        'https://hamo-backend.vercel.app/api/v1/servicedetail/getsepecificserviceman/$serviceManId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final servicedetail= ServiceDetails.fromJson(data);
      final box = Hive.box('servicebox');
      box.put("location", servicedetail.location);
      return servicedetail;
    } else {
      throw Exception('Failed to load service detail');
    }
  }


  Future<List<UserDetail>> fetchUsersByLocation(String location) async {
    final response = await http.get(
      Uri.parse('https://hamo-backend.vercel.app/api/v1/userdetail/alluser/by-location?location=$location'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List users = data['users'];
      return users.map((e) => UserDetail.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

}


