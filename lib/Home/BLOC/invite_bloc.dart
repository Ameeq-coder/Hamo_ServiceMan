import 'package:flutter_bloc/flutter_bloc.dart';
import '../REPO/invite_repository.dart';
import 'invite_event.dart';
import 'invite_state.dart';

class InviteBloc extends Bloc<InviteEvent, InviteState> {
  final InviteRepository repository;

  InviteBloc(this.repository) : super(InviteInitial()) {
    on<SendInviteEvent>((event, emit) async {
      emit(InviteLoading());
      try {
        final data = await repository.sendInvite(
          servicemanId: event.servicemanId,
          userId: event.userId,
        );
        emit(InviteSuccess(data));
      } catch (e) {
        emit(InviteFailure(e.toString()));
      }
    });
  }
}
