import 'dart:developer';
import 'dart:js';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_admin/l10n/l10n.dart';
import 'package:track_admin/management/management.dart';
import 'package:track_admin/repositories/models/user.dart';
import 'package:track_admin/widgets/widgets.dart';
import 'package:track_theme/track_theme.dart';

class AdminDataTable extends StatefulWidget {
  const AdminDataTable({super.key});

  @override
  State<AdminDataTable> createState() => _AdminDataTableState();
}

class _AdminDataTableState extends State<AdminDataTable> {
  //column sorting function
  int sortColumnIndex = 0;
  bool isAscending = true;

  //for pagination
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  //sorting
  onsortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        filterData!.sort((a, b) => a.email!.compareTo(b.email!));
      } else {
        filterData!.sort((a, b) => b.email!.compareTo(a.email!));
      }
    }
  }

  //todo will use if have clear option
  TextEditingController searchController = TextEditingController();
  void clear() {
    myData = filterData!.toList();
    searchController.clear();
  }

  //for dialog
  bool isDialogOpen = false;
  void toggleDialog() {
    isDialogOpen = !isDialogOpen;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    refresh() {
      //call load data function
      context.read<ManagementBloc>().add(DisplayAllAdminRequested());
    }

    List<DataColumn> column = [
      DataColumn(
        label: Text(
          l10n.email,
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
          l10n.displayName,
          style: AppStyle.dtHeader,
        ),
      ),
      DataColumn(
        label: Text(
          l10n.uid,
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
    return BlocListener<ManagementBloc, ManagementState>(
      listener: (context, state) {
        if (state.status == ManagementStatus.failure) {
          switch (state.error) {
            case 'email-already-exists':
              AppSnackBar.error(context, l10n.emailAlreadyInUse);
              break;
            default:
              AppSnackBar.error(context, l10n.unknownError);
          }
        }
        if (state.status == ManagementStatus.success) {
          switch (state.success) {
            case 'added':
              if (isDialogOpen) {
                Navigator.of(context, rootNavigator: true).pop();
              }
              AppSnackBar.success(context, l10n.addedAdmin);
              refresh();
              break;
            case 'disabled':
              AppSnackBar.success(context, l10n.userDisabledSuccess);
              refresh();
              break;
            case 'enabled':
              AppSnackBar.success(context, l10n.userDisabledSuccess);
              refresh();
              break;
            case 'deleted':
              AppSnackBar.success(context, l10n.userDisabledSuccess);
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
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: l10n.searchByUserEmailOrUID,
                    border: InputBorder.none
                    //todo
                    // suffixIcon: IconButton(
                    //   icon: Icon(Icons.close),
                    //   onPressed: () => clear(),
                    // ),
                    ),
                onChanged: (value) {
                  setState(() {
                    myData = filterData!
                        .where((element) =>
                            element.email!
                                .toLowerCase()
                                .contains(value.toLowerCase()) ||
                            element.id.contains(value))
                        .toList();
                  });
                },
              ),
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
                            value: BlocProvider.of<ManagementBloc>(context),
                            child: UserManagementDialog(
                              dialogTitle: l10n.addAdmin,
                              actionName: l10n.add,
                              action: 'addAdmin',
                            ),
                          );
                        }).then((value) {
                      toggleDialog();
                    });
                    toggleDialog();
                  }
                },
                child: Text(l10n.addAdmin),
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
  final List<User> adminData;
  final BuildContext context;

  RowSource(this.adminData, this.context);

  @override
  DataRow? getRow(int index) {
    if (index < rowCount) {
      return recentFileDataRow(adminData![index]);
    } else
      return null;
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => adminData.length;

  @override
  int get selectedRowCount => 0;
}

DataRow recentFileDataRow(var data) {
  if (data.disabled) {
    return DataRow(
      cells: [
        DataCell(Text(
          data.email ?? "",
          style: TextStyle(
            foreground: Paint()..color = Colors.black.withOpacity(0.5),
          ),
        )),
        DataCell(Text(
          data.name ?? "",
          style: TextStyle(
            foreground: Paint()..color = Colors.black.withOpacity(0.5),
          ),
        )),
        DataCell(Text(
          data.id ?? "",
          style: TextStyle(
            foreground: Paint()..color = Colors.black.withOpacity(0.5),
          ),
        )),
        DataCell(
          Builder(builder: (context) {
            return PopupMenuButton(
              icon: Icon(Icons.more_vert_rounded),
              itemBuilder: (context) {
                final l10n = context.l10n;
                return [
                  PopupMenuItem(
                    value: 0,
                    child: Text(l10n.resetPassword),
                  ),
                  PopupMenuItem(
                    value: 1,
                    child: Text(l10n.enableAccount),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Text(l10n.deleteAccount),
                  ),
                ];
              },
              onSelected: (value) {
                switch (value) {
                  case 0:
                    resetPassword(data, context);
                    break;
                  case 1:
                    enableAccount(data, context);
                    break;
                  case 2:
                    deleteAccount(data, context);
                }
              },
            );
          }),
        ),
      ],
    );
  } else {
    return DataRow(
      // color:  MaterialStateProperty.all(Colors.green),
      cells: [
        DataCell(Text(data.email ?? "")),
        DataCell(Text(data.name ?? "")),
        DataCell(Text(data.id ?? "")),
        DataCell(
          Builder(builder: (context) {
            return PopupMenuButton(
              icon: Icon(Icons.more_vert_rounded),
              itemBuilder: (context) {
                final l10n = context.l10n;
                return [
                  PopupMenuItem(
                    value: 0,
                    child: Text(l10n.resetPassword),
                  ),
                  PopupMenuItem(
                    value: 1,
                    child: Text(l10n.disableAccount),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Text(l10n.deleteAccount),
                  ),
                ];
              },
              onSelected: (value) {
                switch (value) {
                  case 0:
                    resetPassword(data, context);
                    break;
                  case 1:
                    disableAccount(data, context);
                    break;
                  case 2:
                    deleteAccount(data, context);
                }
              },
            );
          }),
        ),
      ],
    );
  }
}

//todo
void resetPassword(User data, BuildContext context) {
  log('reset password');
}

disableAccount(User data, BuildContext context) {
  context.read<ManagementBloc>().add(DisableAdminRequested(uid: data.id));
}

void enableAccount(User data, BuildContext context) {
  context.read<ManagementBloc>().add(EnableAdminRequested(uid: data.id));
}

void deleteAccount(User data, BuildContext context) {
  context.read<ManagementBloc>().add(DeleteAdminRequested(uid: data.id));
}
