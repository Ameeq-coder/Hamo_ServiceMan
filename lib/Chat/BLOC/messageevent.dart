// bloc/message_event.dart

import '../Models/messagemodel.dart';

abstract class MessageEvent {}

class ConnectMessage extends MessageEvent {
  final String chatListId;
  ConnectMessage(this.chatListId);
}

class LoadMessages extends MessageEvent {
  final String chatListId;
  LoadMessages(this.chatListId);
}

class SendMessageEvent extends MessageEvent {
  final String chatListId;
  final String senderId;
  final String senderType;
  final String receiverId;
  final String receiverType;
  final String message;
  SendMessageEvent({
    required this.chatListId,
    required this.senderId,
    required this.senderType,
    required this.receiverId,
    required this.receiverType,
    required this.message,
  });
}

class ReceiveMessageEvent extends MessageEvent {
  final MessageModel message;
  ReceiveMessageEvent(this.message);
}