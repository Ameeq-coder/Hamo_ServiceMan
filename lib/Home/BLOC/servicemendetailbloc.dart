import 'package:flutter_bloc/flutter_bloc.dart';
import 'servicemendetailevent.dart';
import 'servicemendetailstate.dart';
import '../REPO/HomeRepo.dart';

class ServiceManDetailsBloc extends Bloc<ServiceDetailsEvent, ServiceDetailsState> {
  final HomeRepo homeRepo;

  ServiceManDetailsBloc({required this.homeRepo}) : super(ServiceDetailInitial()) {
    on<FetchServiceDetailEvent>(_onFetchServiceDetail);
  }

  Future<void> _onFetchServiceDetail(
      FetchServiceDetailEvent event,
      Emitter<ServiceDetailsState> emit,
      ) async {
    emit(ServiceDetailLoading());
    try {
      final serviceDetail = await homeRepo.fetchServiceDetails(event.serviceManId);
      emit(ServiceDetailLoaded(serviceDetail));
    } catch (e) {
      emit(ServiceDetailError('Failed to fetch service detail: ${e.toString()}'));
    }
  }
}
