import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/calendar_model.dart';


class CalendarRepository {
  Future<List<Booking>> fetchBookings(String serviceId, String date) async {
    final url = Uri.parse('https://hamo-backend.vercel.app/api/v1/booking/servicecreated/$serviceId/$date');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final bookings = jsonBody['bookings'] as List;
      return bookings.map((e) => Booking.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load bookings');
    }
  }
}
