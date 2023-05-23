part of 'management_bloc.dart';

enum ManagementStatus { initial, loading, success, failure }


 class ManagementState extends Equatable {
   final ManagementStatus status;
  final String error;
  final List<User> adminUsersList;

  const ManagementState({
    required this.status,
    required this.error,
    required this.adminUsersList,
  });
 
 
 
  //initializing
  factory ManagementState.initial() {
    return const ManagementState(
      status: ManagementStatus.initial,
      error: '',
      adminUsersList: [],
    );
  }
 
 //const ManagementState();
  
  @override
  List<Object> get props => [status, error, adminUsersList];

   ManagementState copyWith({
    ManagementStatus? status,
    String? error,
    List<User>? adminUsersList,
  }) {
    return ManagementState(
      status: status ?? this.status,
      error: error ?? this.error,
      adminUsersList: adminUsersList ?? this.adminUsersList,
    );
  }
}