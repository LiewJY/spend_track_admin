part of 'user_bloc.dart';

enum UserStatus { initial, loading, success, failure }

class UserState extends Equatable {
  final UserStatus status;
  final String error;
  final String success;
  final List<User> usersList;

  const UserState({
    required this.status,
    required this.error,
    required this.success,
    required this.usersList,
  });

  //initializing
  factory UserState.initial() {
    return const UserState(
      status: UserStatus.initial,
      error: '',
      success: '',
      usersList: [],
    );
  }

  //const UserState();

  @override
  List<Object> get props => [status, error, usersList];

  UserState copyWith({
    UserStatus? status,
    String? error,
    String? success,
    List<User>? usersList,
  }) {
    return UserState(
      status: status ?? this.status,
      error: error ?? this.error,
      success: success ?? this.success,
      usersList: usersList ?? this.usersList,
    );
  }
}
