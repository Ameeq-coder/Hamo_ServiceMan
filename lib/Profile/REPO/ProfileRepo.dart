import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/ProfileModel.dart';

class ProfileRepository {
  Future<ProfileModel> fetchProfile(String servicemanId) async {
    final url = 'https://hamo-backend.vercel.app/api/v1/servicedetail/getsepecificserviceman/$servicemanId';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      return ProfileModel.fromJson(jsonBody);
    } else {
      throw Exception('Failed to load profile');
    }
  }
}
