import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_admin/category/category.dart';
import 'package:track_admin/l10n/l10n.dart';
import 'package:track_admin/repositories/models/category.dart';

class CategoryDropDownField extends StatefulWidget {
  const CategoryDropDownField({
    super.key,
    required this.onChanged,
    this.value,
  });

  final onChanged;
  final value;

  @override
  State<CategoryDropDownField> createState() => _CategoryDropDownFieldState();
}

List<DropdownMenuItem> get categoryDropdownItems {
  List<DropdownMenuItem> menuItems = [];
  for (SpendingCategory element in myCategory!) {
    menuItems.add(DropdownMenuItem(
      value: element.toFirestore().toString(),
      child: Text(element.name.toString()),
    ));
  }
  return menuItems;
}

//store category
List<SpendingCategory>? myCategory;

class _CategoryDropDownFieldState extends State<CategoryDropDownField> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(DisplayAllCategoryRequested());
  }

  @override
  Widget build(BuildContext context) {
    //store data of category
    myCategory = context.select((CategoryBloc bloc) => bloc.state.categoryList);

    final l10n = context.l10n;
    String? validator(value) {
      if (value != null) {
        return null;
      } else {
        return l10n.pleaseSelectCategory;
      }
    }

    return Expanded(
      child: DropdownButtonFormField(
        value: widget.value,
        decoration: InputDecoration(
          labelText: l10n.selectCategory,
        ),
        items: categoryDropdownItems,
        onChanged: widget.onChanged,
        validator: validator,
      ),
    );
  }
}
