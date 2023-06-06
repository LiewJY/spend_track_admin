part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class DisplayAllCategoryRequested extends CategoryEvent {
  const DisplayAllCategoryRequested();

  @override
  List<Object> get props => [];
}

class AddCategoryRequested extends CategoryEvent {
  const AddCategoryRequested({required this.name, required this.description});

  final String name;
  final String description;

  @override
  List<Object> get props => [name, description];
}

class UpdateCategoryRequested extends CategoryEvent {
  const UpdateCategoryRequested({required this.uid});

  final String uid;

  @override
  List<Object> get props => [];
}

class DeleteCategoryRequested extends CategoryEvent {
  const DeleteCategoryRequested({required this.uid});

  final String uid;

  @override
  List<Object> get props => [];
}
