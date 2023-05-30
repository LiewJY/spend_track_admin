import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_admin/l10n/l10n.dart';
import 'package:track_admin/management/management.dart';
import 'package:track_admin/repositories/models/user.dart';
import 'package:track_admin/repositories/repositories.dart';
import 'package:track_admin/widgets/widgets.dart';
import 'package:track_theme/track_theme.dart';

class ManagementScereenContent extends StatelessWidget {
  const ManagementScereenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final managementRepository = ManagementRepository();

    return RepositoryProvider.value(
      value: managementRepository,
      child: BlocProvider(
        create: (context) =>
            ManagementBloc(managementRepository: managementRepository),
        child: ListView(
          children: [
            DataLoader(),
          ],
        ),
      ),
    );
  }
}

//list from firebase
List<User>? filterData;
List<User>? myData;

class DataLoader extends StatefulWidget {
  const DataLoader({super.key});

  @override
  State<DataLoader> createState() => _DataLoaderState();
}

class _DataLoaderState extends State<DataLoader> {
  @override
  void initState() {
    super.initState();
    //load data from firebase
    context.read<ManagementBloc>().add(DisplayAllAdminRequested());
  }

  @override
  Widget build(BuildContext context) {
    myData = context.select((ManagementBloc bloc) => bloc.state.adminUsersList);

    filterData = myData!;
    return AdminDataTable();
  }
}

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

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    List<DataColumn> column = [
      DataColumn(
        label:  Text(
          l10n.email,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
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
        label:  Text(
          l10n.displayName,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
      DataColumn(
        label:  Text(
          l10n.uid,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
      const DataColumn(
        label: Text(
          "",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
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
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: FilledButton(
              //todo
              onPressed: () => log('todo'),
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
      log('table    ' + adminData[index].toString());
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
  return DataRow(
    cells: [
      DataCell(Text(data.email ?? "")),
      DataCell(Text(data.name ?? "")),
      DataCell(Text(data.id ?? "")),
      //todo
      DataCell(ElevatedButton(
        child: Text('d'),
        onPressed: () => log('ff ' + data.email),
      )),
    ],
  );
}
