import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:track_admin/repositories/models/category.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryState.initial()) {
    on<DisplayAllCategoryRequested>(_onDisplayAllCategoryRequested);
    on<AddCategoryRequested>(_onAddCategoryRequested);
    on<UpdateCategoryRequested>(_onUpdateCategoryRequested);
    on<DeleteCategoryRequested>(_onDeleteCategoryRequested);
  }

  //actions
  _onDisplayAllCategoryRequested(
    DisplayAllCategoryRequested event,
    Emitter emit,
  ) {
    //todo
  }
  _onAddCategoryRequested(
    AddCategoryRequested event,
    Emitter emit,
  ) {
    //todo
  }
  _onUpdateCategoryRequested(
    UpdateCategoryRequested event,
    Emitter emit,
  ) {
    //todo
  }
  _onDeleteCategoryRequested(
    DeleteCategoryRequested event,
    Emitter emit,
  ) {
    //todo
  }
}
