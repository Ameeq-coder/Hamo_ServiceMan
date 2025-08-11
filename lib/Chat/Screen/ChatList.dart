import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../REPO/chat_repository.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get userId from Hive
    // final box = Hive.box('servicebox');
    // final servicemenid = box.get('servicemanid') ?? '';
    final servicemenid="srv_b1tC9h4orq";

    return BlocProvider(
      create: (_) => ChatBloc(ChatRepository())..add(LoadUserChats(servicemenid)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Chats'),
          backgroundColor: Colors.white,
          elevation: 1,
        ),
        body: SafeArea(
          child: BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              if (state is ChatLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ChatError) {
                return Center(child: Text('Error: ${state.message}'));
              }

              if (state is ChatLoaded) {
                final chats = state.chats;

                if (chats.isEmpty) {
                  return const Center(child: Text("No chats available"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];

                    return ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(chat.user.imageUrl),
                      ),
                      title: Text(
                        chat.user.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        chat.lastMessage,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${chat.createdAt.hour}:${chat.createdAt.minute.toString().padLeft(2, '0')}",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 5),
                          if (chat.onlineStatus)
                            Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      onTap: () {
                        // Navigate to individual chat page
                      },
                    );
                  },
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
