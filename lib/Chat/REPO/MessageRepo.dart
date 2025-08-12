// repository/message_repository.dart
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;
import '../Models/messagemodel.dart';

class MessageRepository {
  final String wsUrl;
  final String apiBaseUrl;
  WebSocketChannel? _channel;

  MessageRepository({
    required this.wsUrl,
    this.apiBaseUrl = 'https://hamo-backend.vercel.app/api/v1',
  });

  // Fetch historical messages from API
  Future<List<MessageModel>> fetchMessages(String chatListId) async {
    try {
      final response = await http.get(
        Uri.parse('https://hamo-backend.vercel.app/api/v1/chat/messages/$chatListId'),
        // headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => MessageModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch messages: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching messages: $e');
    }
  }

  void connect(String chatListId) {
    _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
    _channel!.sink.add(jsonEncode({
      "type": "join",
      "chatListId": chatListId,
    }));
  }

  Stream<MessageModel> get messages async* {
    if (_channel != null) {
      await for (var event in _channel!.stream) {
        final decoded = jsonDecode(event);
        if (decoded['type'] == 'new_message') {
          yield MessageModel.fromJson(decoded['message']);
        }
      }
    }
  }

  void sendMessage({
    required String chatListId,
    required String senderId,
    required String senderType,
    required String receiverId,
    required String receiverType,
    required String message,
  }) {
    _channel?.sink.add(jsonEncode({
      "type": "send_message",
      "chatListId": chatListId,
      "senderId": senderId,
      "senderType": senderType,
      "recevierid": receiverId,
      "receviertype": receiverType,
      "message": message,
    }));
  }

  void disconnect() {
    _channel?.sink.close();
  }
}