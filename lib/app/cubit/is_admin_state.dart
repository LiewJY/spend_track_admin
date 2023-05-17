part of 'is_admin_cubit.dart';

enum IsAdminStatus { initial, loading, valid, invalid }

class IsAdminState extends Equatable {
  final IsAdminStatus status;
  final String error;

  const IsAdminState({
    required this.status,
    required this.error,
  });

  //initializing
  factory IsAdminState.initial() {
    return const IsAdminState(
      status: IsAdminStatus.initial,
      error: '',
    );
  }

  @override
  List<Object> get props => [status, error];

  IsAdminState copyWith({
    IsAdminStatus? status,
    String? error,
  }) {
    return IsAdminState(
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
