// screens/msg_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../BLOC/MessageBloc.dart';
import '../BLOC/MessageState.dart';
import '../BLOC/chat_bloc.dart';
import '../BLOC/messageevent.dart';
import '../REPO/chat_repository.dart';
import 'ChatList.dart';

class MsgScreen extends StatefulWidget {
  final String chatListId;
  final String receiverId;
  final String receiverType;
  final String name;
  final String imgurl;

  const MsgScreen({
    super.key,
    required this.chatListId,
    required this.receiverId,
    required this.receiverType,
    required this.name, required this.imgurl,
  });

  @override
  State<MsgScreen> createState() => _MsgScreenState();
}

class _MsgScreenState extends State<MsgScreen> {
  final _controller = TextEditingController();
  late String servicemenid;
  late final String username;
  late final imgurl;
  @override
  void initState() {
    super.initState();
    final box = Hive.box('servicebox');
    servicemenid = box.get('servicemanid');
    username = widget.name;
    imgurl=widget.imgurl;
    // First load historical messages, then connect to WebSocket
    context.read<MessageBloc>().add(LoadMessages(widget.chatListId));
    context.read<MessageBloc>().add(ConnectMessage(widget.chatListId));
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (_) => ChatBloc(ChatRepository()),
                  child:  ChatScreen(),
                ),
              ),
            );
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(imgurl),
            ),
            const SizedBox(width: 8),
            Text(
              username,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: const [
          Icon(Icons.call, color: Colors.black),
          SizedBox(width: 15),
          SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          const Text(
            "",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: BlocBuilder<MessageBloc, MessageState>(
              builder: (context, state) {
                if (state is MessageLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MessageError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.error,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<MessageBloc>().add(LoadMessages(widget.chatListId));
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else if (state is MessageLoaded) {
                  if (state.messages.isEmpty) {
                    return const Center(child: Text("No messages yet"));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final msg = state.messages[index];
                      final isSender = msg.senderId == servicemenid;
                      final createdAt = DateTime.parse(msg.createdAt);

                      return _buildMessage(
                        msg.message,
                        isSender,
                        _formatTime(createdAt),
                      );
                    },
                  );
                }
                return const Center(child: Text("No messages yet"));
              },
            ),
          ),
          _buildTextInput(),
        ],
      ),
    );
  }

  Widget _buildMessage(String text, bool isSender, String time) {
    return Column(
      crossAxisAlignment:
      isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSender ? Colors.purpleAccent : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isSender ? Colors.white : Colors.black87,
              fontSize: 14,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 4, left: 4, right: 4),
          child: Text(
            time,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildTextInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: "Message...",
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          suffixIcon: IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              if (_controller.text.trim().isNotEmpty) {
                context.read<MessageBloc>().add(SendMessageEvent(
                  chatListId: widget.chatListId,
                  senderId: servicemenid,
                  senderType: "servicemen",
                  receiverId: widget.receiverId,
                  receiverType: "user",
                  message: _controller.text.trim(),
                ));
                _controller.clear();
              }
            },
          ),
          fillColor: Colors.grey.shade100,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}