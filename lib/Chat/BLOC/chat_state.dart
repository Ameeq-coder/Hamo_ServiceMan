import 'package:equatable/equatable.dart';
import '../Models/chat_model.dart';

abstract class ChatState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<Chat> chats;
  ChatLoaded(this.chats);

  @override
  List<Object?> get props => [chats];
}

class ChatError extends ChatState {
  final String message;
  ChatError(this.message);

  @override
  List<Object?> get props => [message];
}
