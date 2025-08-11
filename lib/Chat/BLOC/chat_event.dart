import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadUserChats extends ChatEvent {
  final String userId;
  LoadUserChats(this.userId);

  @override
  List<Object?> get props => [userId];
}
