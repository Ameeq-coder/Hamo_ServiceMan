import 'package:equatable/equatable.dart';

abstract class InviteEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SendInviteEvent extends InviteEvent {
  final String servicemanId;
  final String userId;

  SendInviteEvent({required this.servicemanId, required this.userId});

  @override
  List<Object?> get props => [servicemanId, userId];
}
