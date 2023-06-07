import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_admin/category/bloc/category_bloc.dart';
import 'package:track_admin/category/category.dart';
import 'package:track_admin/l10n/l10n.dart';
import 'package:track_admin/repositories/models/category.dart';
import 'package:track_admin/widgets/widgets.dart';
import 'package:track_theme/track_theme.dart';

class CategoryDataTable extends StatefulWidget {
  const CategoryDataTable({super.key});

  @override
  State<CategoryDataTable> createState() => _CategoryDataTableState();
}

//for dialog
bool isDialogOpen = false;
void toggleDialog() {
  isDialogOpen = !isDialogOpen;
}

class _CategoryDataTableState extends State<CategoryDataTable> {
  //column sorting function
  int sortColumnIndex = 0;
  bool isAscending = true;

  //for pagination
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  //sorting
  onsortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        filterData!.sort((a, b) => a.name!.compareTo(b.name!));
      } else {
        filterData!.sort((a, b) => b.name!.compareTo(a.name!));
      }
    }
  }

  //todo will use if have clear option
  TextEditingController searchController = TextEditingController();
  void clear() {
    myData = filterData!.toList();
    searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    refresh() {
      //call load data function
      context.read<CategoryBloc>().add(DisplayAllCategoryRequested());
    }

    List<DataColumn> column = [
      DataColumn(
        label: Text(
          l10n.categoryName,
          style: AppStyle.dtHeader,
        ),
        onSort: ((columnIndex, ascending) {
          setState(() {
            sortColumnIndex = columnIndex;
            isAscending = ascending;
          });
          onsortColum(columnIndex, ascending);
        }),
      ),
      DataColumn(
        label: Text(
          l10n.description,
          style: AppStyle.dtHeader,
        ),
      ),
      const DataColumn(
        label: Text(
          "",
          style: AppStyle.dtHeader,
        ),
      ),
    ];

// return Placeholder();
    return BlocListener<CategoryBloc, CategoryState>(
      listener: (context, state) {
        if (state.status == CategoryStatus.failure) {
          switch (state.error) {
            // case 'email-already-exists':
            //   AppSnackBar.error(context, l10n.emailAlreadyInUse);
            //   break;
            default:
              AppSnackBar.error(context, l10n.unknownError);
          }
        }
        if (state.status == CategoryStatus.success) {
          switch (state.success) {
            case 'added':
              if (isDialogOpen) {
                Navigator.of(context, rootNavigator: true).pop();
              }
              AppSnackBar.success(context, l10n.addedAdmin);
              refresh();
              break;
            case 'updated':
              if (isDialogOpen) {
                Navigator.of(context, rootNavigator: true).pop();
              }
              AppSnackBar.success(context, l10n.categoryUpdatedSuccess);
              refresh();
              break;
            case 'deleted':
              AppSnackBar.success(context, l10n.categoryDeleteSuccess);
              refresh();
              break;
          }
        }
      },
      child: PaginatedDataTable(
        sortAscending: isAscending,
        header: Row(
          children: [
            Expanded(
              flex: 7,
              child: DataTableSearchField(
                  hintText: l10n.searchByCategoryName,
                  controller: searchController,
                  action: (value) {
                    setState(() {
                      myData = filterData!
                          .where((element) => element.name!
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .toList();
                    });
                  }),
            ),
            Padding(
              padding: AppStyle.dtButonHorizontalPadding,
              child: FilledButton(
                onPressed: () {
                  if (!isDialogOpen) {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return BlocProvider.value(
                            value: BlocProvider.of<CategoryBloc>(context),
                            child: CategoryDialog(
                              dialogTitle: l10n.addCategory,
                              actionName: l10n.add,
                              action: 'addCategory',
                            ),
                          );
                        }).then((value) {
                      toggleDialog();
                    });
                    toggleDialog();
                  }
                },
                child: Text(l10n.addCategory),
              ),
            ),
          ],
        ),
        sortColumnIndex: sortColumnIndex,
        rowsPerPage: _rowsPerPage,
        onRowsPerPageChanged: (rowCount) {
          setState(() {
            _rowsPerPage = rowCount!;
          });
        },
        columns: column,
        source: RowSource(myData!, context),
      ),
    );
  }
}

//data source
class RowSource extends DataTableSource {
  //extract the data param passed
  final List<SpendingCategory> categoryData;
  final BuildContext context;

  RowSource(this.categoryData, this.context);

  @override
  DataRow? getRow(int index) {
    if (index < rowCount) {
      return recentFileDataRow(categoryData![index]);
    } else
      return null;
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => categoryData.length;

  @override
  int get selectedRowCount => 0;
}

DataRow recentFileDataRow(SpendingCategory data) {
  return DataRow(
    cells: [
      DataCell(Text(
        data.name ?? "",
      )),
      DataCell(Text(
        data.description ?? "",
      )),
      DataCell(
        Builder(builder: (context) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PopupMenuButton(
                icon: Icon(Icons.more_vert_rounded),
                itemBuilder: (context) {
                  final l10n = context.l10n;
                  return [
                    PopupMenuItem(
                      value: 0,
                      child: Text(l10n.editCategory),
                    ),
                    PopupMenuItem(
                      value: 1,
                      child: Text(l10n.deleteCategory),
                    ),
                  ];
                },
                onSelected: (value) {
                  switch (value) {
                    case 0:
                      editCategory(data, context);
                      break;
                    case 1:
                      deleteCategory(data, context);
                      break;
                  }
                },
              ),
            ],
          );
        }),
      ),
    ],
  );
}

//todo
void editCategory(SpendingCategory data, BuildContext context) {
  final l10n = context.l10n;
  if (!isDialogOpen) {
    showDialog(
        context: context,
        builder: (_) {
          return BlocProvider.value(
            value: BlocProvider.of<CategoryBloc>(context),
            child: CategoryDialog(
              dialogTitle: l10n.editCategory,
              actionName: l10n.update,
              action: 'editCategory',
              data: data,
            ),
          );
        }).then((value) {
      toggleDialog();
    });
    toggleDialog();
  }
}

void deleteCategory(SpendingCategory data, BuildContext context) {
  context.read<CategoryBloc>().add(DeleteCategoryRequested(uid: data.uid!));
}
