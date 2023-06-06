part of 'category_bloc.dart';

enum CategoryStatus { initial, loading, success, failure }

class CategoryState extends Equatable {
  final CategoryStatus status;
  final String error;
  final String success;
  final List<SpendingCategory> categoryList;

  const CategoryState({
    required this.status,
    required this.error,
    required this.success,
    required this.categoryList,
  });

  //initializing
  factory CategoryState.initial() {
    return const CategoryState(
      status: CategoryStatus.initial,
      error: '',
      success: '',
      categoryList: [],
    );
  }

  @override
  List<Object> get props => [status, error, success,categoryList];

  CategoryState copyWith({
    CategoryStatus? status,
    String? error,
    String? success,
    List<SpendingCategory>? categoryList,
  }) {
    return CategoryState(
      status: status ?? this.status,
      error: error ?? this.error,
      success: success ?? this.success,
      categoryList: categoryList ?? this.categoryList,
    );
  }
}
