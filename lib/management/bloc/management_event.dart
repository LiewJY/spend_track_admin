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
const AddAdminRequested({required this.email, required this.password, required this.name});

  final String email;
  final String password;
  final String name;

  @override
  List<Object> get props => [email, password, name];
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
