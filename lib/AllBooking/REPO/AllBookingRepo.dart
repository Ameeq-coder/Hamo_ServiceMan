import 'dart:convert';
import 'package:http/http.dart' as http;
import '../MODEL/AllBoookingModel.dart';

class AllBookingsRepository {
  Future<List<AllBooking>> fetchAllBookings(String servicemanId) async {
    final url = 'https://hamo-backend.vercel.app/api/v1/booking/allbookings/serviceman/$servicemanId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List bookingsJson = data['bookings'];
      return bookingsJson.map((json) => AllBooking.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load bookings');
    }
  }
}