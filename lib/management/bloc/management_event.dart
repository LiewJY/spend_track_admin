part of 'management_bloc.dart';

abstract class ManagementEvent extends Equatable {
  const ManagementEvent();

  @override
  List<Object> get props => [];
}

class DisplayAllAdminRequested extends ManagementEvent {
  const DisplayAllAdminRequested();

  @override
  List<Object> get props => [];
}
