import 'package:flutter_bloc/flutter_bloc.dart';
import '../REPO/user_repository.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository repository;

  UserBloc(this.repository) : super(UserInitial()) {
    on<FetchUsersByLocationEvent>((event, emit) async {
      emit(UserLoading());
      try {
        final users = await repository.fetchUsersByLocation(event.location);
        emit(UserLoaded(users));
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });
  }
}
