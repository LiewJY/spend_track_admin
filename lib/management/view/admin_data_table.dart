import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:track_admin/l10n/l10n.dart';
import 'package:track_admin/management/management.dart';
import 'package:track_admin/repositories/models/user.dart';
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

    return PaginatedDataTable(
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
              //todo
              onPressed: () {
                if (!isDialogOpen) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AddAdminDialog();
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
      source: RowSource(myData!),
    );
  }
}

//data source
class RowSource extends DataTableSource {
  //extract the data param passed
  final List<User> adminData;

  RowSource(this.adminData);

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
        //todo
        DataCell(
          PopupMenuButton(
            icon: Icon(Icons.more_vert_rounded),
            itemBuilder: (context) {
              final l10n = context.l10n;
              return [
                PopupMenuItem(
                  value: 0,
                  child: Text(l10n.editUser),
                ),
                PopupMenuItem(
                  value: 1,
                  child: Text(l10n.enableUser),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Text(l10n.deleteUser),
                ),
              ];
            },
            onSelected: (value) {
              switch (value) {
                case 0:
                  editUser(data);
                  break;
                case 1:
                  enableUser(data);
                  break;
                case 2:
                  deleteUser(data);
              }
            },
          ),
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
          PopupMenuButton(
            icon: Icon(Icons.more_vert_rounded),
            itemBuilder: (context) {
              final l10n = context.l10n;
              return [
                PopupMenuItem(
                  value: 0,
                  child: Text(l10n.editUser),
                ),
                PopupMenuItem(
                  value: 1,
                  child: Text(l10n.disableUser),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Text(l10n.deleteUser),
                ),
              ];
            },
            onSelected: (value) {
              switch (value) {
                case 0:
                  editUser(data);
                  break;
                case 1:
                  disableUser(data);
                  break;
                case 2:
                  deleteUser(data);
              }
            },
          ),
        ),
      ],
    );
  }
}

void editUser(User data) {
  log('edit user');
}

void deleteUser(User data) {
  log('delete user');
}

void enableUser(User data) {
  log('enable user');
}

void disableUser(User data) {
  log('disable user');
}
