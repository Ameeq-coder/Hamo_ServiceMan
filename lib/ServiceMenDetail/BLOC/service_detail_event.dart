import 'package:equatable/equatable.dart';
import '../Models/ServiceDetailModel.dart';

abstract class ServiceDetailEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SubmitServiceDetailEvent extends ServiceDetailEvent {
  final ServiceDetailModel model;

  SubmitServiceDetailEvent(this.model);

  @override
  List<Object> get props => [model];
}
