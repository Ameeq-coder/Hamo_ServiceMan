import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hamo_service_man/Auth/Repositry/SignupRepositry.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final SignupRepository signupRepository;

  SignupBloc({required this.signupRepository}) : super(SignupInitial()) {
    on<SignupSubmitted>((event, emit) async {
      emit(SignupLoading());
      try {
        final serviceman = await signupRepository.signupServiceman(
          email: event.email,
          password: event.password,
          serviceType: event.serviceType,
        );
        emit(SignupSuccess(id: serviceman.id, email: serviceman.email));
      } catch (e) {
        emit(SignupFailure(error: e.toString()));
      }
    });
  }
}
