import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_detail_model.dart';

class UserRepository {
  Future<List<UserDetail>> fetchUsersByLocation(String location) async {
    final url = 'https://hamo-backend.vercel.app/api/v1/userdetail/alluser/by-location?location=$location';
    print('🔍 Fetching users from: $url');

    try {
      final response = await http.get(Uri.parse(url));

      print('📡 Status Code: ${response.statusCode}');
      print('📦 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['users'] == null) {
          throw Exception('No "users" key found in response.');
        }

        List users = data['users'];
        return users.map((e) => UserDetail.fromJson(e)).toList();
      } else {
        throw Exception('API request failed with status ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('❌ Error: $e');
      print('📜 StackTrace: $stackTrace');
      rethrow;
    }
  }
}
