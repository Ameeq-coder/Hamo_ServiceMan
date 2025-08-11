import 'package:equatable/equatable.dart';
import '../models/invite_model.dart';

abstract class InviteState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InviteInitial extends InviteState {}

class InviteLoading extends InviteState {}

class InviteSuccess extends InviteState {
  final InviteResponse response;
  InviteSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class InviteFailure extends InviteState {
  final String error;
  InviteFailure(this.error);

  @override
  List<Object?> get props => [error];
}
