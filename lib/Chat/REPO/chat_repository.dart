import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Models/chat_model.dart';

class ChatRepository {
  Future<List<Chat>> fetchUserChats(String servicemenid) async {




    final url = Uri.parse(
      'https://hamo-backend.vercel.app/api/v1/chat/serviceman-chats/$servicemenid',
    );

    print(url);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Chat.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load chats: ${response.statusCode}');
    }
  }
}
