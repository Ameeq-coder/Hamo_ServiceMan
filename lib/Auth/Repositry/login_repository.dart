import 'dart:convert';
import 'package:hamo_service_man/Auth/Model/login_model.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  final String baseUrl = "https://hamo-backend.vercel.app/api/v1/serviceauth";

  Future<LoginResponse> loginServiceman(String email, String password) async {
    final url = Uri.parse('$baseUrl/login-serviceman');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final login= LoginResponse.fromJson(data);
      final box = Hive.box('servicebox');
      box.put('servicemanid', login.serviceman.id);
      return login;
    } else {
      throw Exception("Failed to login: ${response.body}");
    }
  }
}
