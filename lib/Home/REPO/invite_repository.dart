import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/invite_model.dart';

class InviteRepository {
  final String baseUrl = 'https://hamo-backend.vercel.app/api/v1';

  Future<InviteResponse> sendInvite({
    required String servicemanId,
    required String userId,
  }) async {
    final url = Uri.parse('$baseUrl/invites/send');    final response = await http.post(


      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'servicemanId': servicemanId,
        'userId': userId,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return InviteResponse.fromJson(jsonDecode(response.body));
    } else if(response.statusCode==409){
      throw Exception('An invite is already pending.');
    }else{
      throw Exception('Failed to send invite}');
    }
  }
}
