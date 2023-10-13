import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:track_admin/repositories/models/category.dart';
import 'package:track_admin/repositories/repositories.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository categoryRepository;
  CategoryBloc({required this.categoryRepository})
      : super(CategoryState.initial()) {
    on<DisplayAllCategoryRequested>(_onDisplayAllCategoryRequested);
    on<AddCategoryRequested>(_onAddCategoryRequested);
    on<UpdateCategoryRequested>(_onUpdateCategoryRequested);
    on<DeleteCategoryRequested>(_onDeleteCategoryRequested);
  }

  //actions
  _onDisplayAllCategoryRequested(
    DisplayAllCategoryRequested event,
    Emitter emit,
  ) async {
    if (state.status == CategoryStatus.loading) return;
    emit(state.copyWith(status: CategoryStatus.loading));
    try {
      List<SpendingCategory> categoryList =
          await categoryRepository.getCategories();
      emit(state.copyWith(
        status: CategoryStatus.success,
        success: 'loadedData',
        categoryList: categoryList,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CategoryStatus.failure,
        error: e.toString(),
      ));
    }
  }

  _onAddCategoryRequested(
    AddCategoryRequested event,
    Emitter emit,
  ) {
    if (state.status == CategoryStatus.loading) return;
    emit(state.copyWith(status: CategoryStatus.loading));
    try {
      //todo
      categoryRepository.addCategory(
        name: event.name,
        description: event.description,
        color: event.color,
      );
      emit(state.copyWith(
        status: CategoryStatus.success,
        success: 'added',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CategoryStatus.failure,
        error: e.toString(),
      ));
    }
  }

  _onUpdateCategoryRequested(
    UpdateCategoryRequested event,
    Emitter emit,
  ) async {
    if (state.status == CategoryStatus.loading) return;
    emit(state.copyWith(status: CategoryStatus.loading));
    try {
      await categoryRepository.updateCategory(
        uid: event.uid,
        name: event.name,
        description: event.description,
                color: event.color,

      );
      emit(state.copyWith(
        status: CategoryStatus.success,
        success: 'updated',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CategoryStatus.failure,
        error: e.toString(),
      ));
    }
  }

  _onDeleteCategoryRequested(
    DeleteCategoryRequested event,
    Emitter emit,
  ) async {
    if (state.status == CategoryStatus.loading) return;
    emit(state.copyWith(status: CategoryStatus.loading));
    try {
      await categoryRepository.deleteCategory(uid: event.uid);
      emit(state.copyWith(
        status: CategoryStatus.success,
        success: 'deleted',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CategoryStatus.failure,
        error: e.toString(),
      ));
    }
  }
}
