import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hamo_service_man/Auth/Repositry/login_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());

      try {
        final loginResponse = await authRepository.loginServiceman(
          event.email,
          event.password,
        );

        emit(AuthSuccess(loginResponse.token));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}
