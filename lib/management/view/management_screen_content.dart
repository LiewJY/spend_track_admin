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

class ManagementScereenContent extends StatelessWidget {
  const ManagementScereenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final managementRepository = ManagementRepository();

// //for datatable
//     final List<DataColumn> colHeader = [
//       DataColumn(label: Text('Header A')),
//       DataColumn(label: Text('Header B')),
//       DataColumn(label: Text('Header C')),
//       DataColumn(label: Text('Header D')),
//     ];

    return RepositoryProvider.value(
      value: managementRepository,
      child: BlocProvider(
        create: (context) =>
            ManagementBloc(managementRepository: managementRepository),
        child: ListView(
          children: [
            AdminDataTable(),
          ],
        ),
      ),
    );
  }
}

class AdminDataTable extends StatefulWidget {
  const AdminDataTable({super.key});

  @override
  State<AdminDataTable> createState() => _AdminDataTableState();
}

class _AdminDataTableState extends State<AdminDataTable> {
  //list from firebase
  List<User>? filterData;

  @override
  void initState() {
    super.initState();
    //load data from firebase
    context.read<ManagementBloc>().add(DisplayAllAdminRequested());
  }

  //column sorting function
  int sortColumnIndex = 0;
  bool isAscending = true;

  //for searching
  TextEditingController controller = TextEditingController();

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
    // if (columnIndex == 2) {
    //   if (ascending) {
    //     filterData!.sort((a, b) => a.Age!.compareTo(b.Age!));
    //   } else {
    //     filterData!.sort((a, b) => b.Age!.compareTo(a.Age!));
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    var originalData =
        context.select((ManagementBloc bloc) => bloc.state.adminUsersList);

    filterData = originalData;

    //datatable column
    List<DataColumn> column = [
      DataColumn(
        label: const Text(
          "Email",
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
        label: const Text(
          "Display name",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
      DataColumn(
        label: const Text(
          "UID",
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
      columns: column,
      source: RowSource(originalData!),
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
  return DataRow(
    cells: [
      DataCell(Text(data.email ?? "email")),
      DataCell(Text(data.name ?? "email")),
      DataCell(Text(data.id ?? "email")),
      //todo
      DataCell(ElevatedButton(
        child: Text('d'),
        onPressed: () => log('ff ' + data.email),
      )),
    ],
  );
}
