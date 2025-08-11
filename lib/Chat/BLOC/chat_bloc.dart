import 'package:flutter_bloc/flutter_bloc.dart';
import '../REPO/chat_repository.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository repository;

  ChatBloc(this.repository) : super(ChatInitial()) {
    on<LoadUserChats>((event, emit) async {
      emit(ChatLoading());
      try {
        final chats = await repository.fetchUserChats(event.userId);
        emit(ChatLoaded(chats));
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });
  }
}
