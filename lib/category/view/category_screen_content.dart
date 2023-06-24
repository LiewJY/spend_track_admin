import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_admin/category/bloc/category_bloc.dart';
import 'package:track_admin/category/category.dart';
import 'package:track_admin/l10n/l10n.dart';
import 'package:track_admin/management/view/management_screen_content.dart';
import 'package:track_admin/repositories/models/category.dart';
import 'package:track_admin/repositories/repositories.dart';
import 'package:track_admin/widgets/widgets.dart';

import '../../repositories/models/user.dart';
import 'package:firebase_admin/firebase_admin.dart';

class CategoryScereenContent extends StatelessWidget {
  const CategoryScereenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final categoryRepository = CategoryRepository();

    return RepositoryProvider.value(
      value: categoryRepository,
      child: BlocProvider(
        create: (context) => CategoryBloc(categoryRepository: categoryRepository),
        child: ListView( 
          children: [
            PageTitleText(title: l10n.category),
            CategoryDataLoader(),
          ],
        ),
      ),
    );
  }
}

//list from firebase
List<SpendingCategory>? filterData;
List<SpendingCategory>? myData;

class CategoryDataLoader extends StatefulWidget {
  const CategoryDataLoader({super.key});

  @override
  State<CategoryDataLoader> createState() => _CategoryDataLoaderState();
}

class _CategoryDataLoaderState extends State<CategoryDataLoader> {
  @override
  void initState() {
    super.initState();
    //load data from firebase
    context.read<CategoryBloc>().add(DisplayAllCategoryRequested());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    myData = context.select((CategoryBloc bloc) => bloc.state.categoryList);

    filterData = myData!;
    return BlocListener<CategoryBloc, CategoryState>(
      listener: (context, state) {
        if (state.status == CategoryStatus.failure) {
          switch (state.error) {
            case 'cannotRetrieveData':
              AppSnackBar.error(context, l10n.cannotRetrieveData);
              break;
          }
        }
        if (state.status == CategoryStatus.success) {
          switch (state.success) {
            case 'loadedData':
              //reload the data table when data is loaded
              setState(() {});
              break;
          }
        }
      },
      child: CategoryDataTable(),
    );
  }
}
