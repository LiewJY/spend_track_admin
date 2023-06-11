part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class DisplayAllUserRequested extends UserEvent {
  const DisplayAllUserRequested();

  @override
  List<Object> get props => [];
}

class AddUserRequested extends UserEvent {
  const AddUserRequested({
    required this.email,
    required this.password,
    required this.name,
  });

  final String email;
  final String password;
  final String name;

  @override
  List<Object> get props => [email, password, name];
}

class DisableUserRequested extends UserEvent {
  const DisableUserRequested({required this.uid});

  final String uid;

  @override
  List<Object> get props => [uid];
}

class EnableUserRequested extends UserEvent {
  const EnableUserRequested({required this.uid});

  final String uid;

  @override
  List<Object> get props => [uid];
}

class DeleteUserRequested extends UserEvent {
  const DeleteUserRequested({required this.uid});

  final String uid;

  @override
  List<Object> get props => [uid];
}
