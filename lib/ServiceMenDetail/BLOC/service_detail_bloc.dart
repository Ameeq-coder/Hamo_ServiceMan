import 'package:flutter_bloc/flutter_bloc.dart';
import '../REPO/ServiceDetailRepository.dart';
import 'service_detail_event.dart';
import 'service_detail_state.dart';

class ServiceDetailsBloc extends Bloc<ServiceDetailEvent, ServiceDetailState> {
  final ServiceDetailRepository repository;

  ServiceDetailsBloc(this.repository) : super(ServiceDetailInitial()) {
    on<SubmitServiceDetailEvent>((event, emit) async {
      emit(ServiceDetailLoading());
      try {
        final response = await repository.createService(event.model);
        emit(ServiceDetailSuccess(response));
      } catch (e) {
        emit(ServiceDetailFailure(e.toString()));
      }
    });
  }
}
