// bloc/message_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Models/messagemodel.dart';
import '../REPO/MessageRepo.dart';
import 'MessageState.dart';
import 'messageevent.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final MessageRepository repository;
  List<MessageModel> _messages = [];

  MessageBloc(this.repository) : super(MessageInitial()) {

    // Load historical messages from API
    on<LoadMessages>((event, emit) async {
      emit(MessageLoading());
      try {
        final messages = await repository.fetchMessages(event.chatListId);
        _messages = messages;
        emit(MessageLoaded(List.from(_messages)));
      } catch (e) {
        emit(MessageError('Failed to load messages: $e'));
      }
    });

    // Connect to WebSocket for real-time messages
    on<ConnectMessage>((event, emit) {
      repository.connect(event.chatListId);
      repository.messages.listen((msg) {
        add(ReceiveMessageEvent(msg));
      });
    });

    // Send message via WebSocket
    on<SendMessageEvent>((event, emit) {
      repository.sendMessage(
        chatListId: event.chatListId,
        senderId: event.senderId,
        senderType: event.senderType,
        receiverId: event.receiverId,
        receiverType: event.receiverType,
        message: event.message,
      );
    });

    // Receive new message from WebSocket
    on<ReceiveMessageEvent>((event, emit) {
      // Check if message already exists to avoid duplicates
      final messageExists = _messages.any((msg) => msg.id == event.message.id);
      if (!messageExists) {
        _messages.add(event.message);
        emit(MessageLoaded(List.from(_messages)));
      }
    });
  }
}