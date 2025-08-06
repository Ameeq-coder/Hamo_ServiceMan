import 'dart:convert';
import 'package:hamo_service_man/Auth/Model/SignupModel.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class SignupRepository {
  Future<SignupModel> signupServiceman({
    required String email,
    required String password,
    required String serviceType,
  }) async {
    final url = Uri.parse("https://hamo-backend.vercel.app/api/v1/serviceauth/signup-serviceman");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
        "serviceType": serviceType,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = jsonDecode(response.body);
      final servicemen= SignupModel.fromJson(body['serviceman']);
      final box = Hive.box('servicebox');
      box.put("servicetype", servicemen.serviceType );
      return servicemen;
    } else {
      throw Exception("Signup failed: ${response.body}");
    }
  }
}
