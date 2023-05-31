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

class AddAdminRequested extends ManagementEvent {
  const AddAdminRequested();

  @override
  List<Object> get props => [];
}

class EditAdminRequested extends ManagementEvent {
  const EditAdminRequested();

  @override
  List<Object> get props => [];
}

class DisableAdminRequested extends ManagementEvent {
  const DisableAdminRequested();

  @override
  List<Object> get props => [];
}

class EnableAdminRequested extends ManagementEvent {
  const EnableAdminRequested();

  @override
  List<Object> get props => [];
}

class DeleteAdminRequested extends ManagementEvent {
  const DeleteAdminRequested();

  @override
  List<Object> get props => [];
}
