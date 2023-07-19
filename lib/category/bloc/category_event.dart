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
  const AddCategoryRequested({required this.name, required this.description, required this.color});

  final String name;
  final String description;
  final String color;

  @override
  List<Object> get props => [name, description, color];
}

class UpdateCategoryRequested extends CategoryEvent {
  const UpdateCategoryRequested(
      {required this.uid, required this.name, required this.description, required this.color});

  final String uid;
  final String name;
  final String description;
  final String color;

  @override
  List<Object> get props => [name, description, color];
}

class DeleteCategoryRequested extends CategoryEvent {
  const DeleteCategoryRequested({required this.uid});

  final String uid;

  @override
  List<Object> get props => [uid];
}
