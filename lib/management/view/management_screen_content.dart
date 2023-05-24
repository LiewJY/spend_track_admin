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

//for datatable
    final List<DataColumn> colHeader = [
      DataColumn(label: Text('Header A')),
      DataColumn(label: Text('Header B')),
      DataColumn(label: Text('Header C')),
      DataColumn(label: Text('Header D')),
    ];

    return RepositoryProvider.value(
      value: managementRepository,
      child: BlocProvider(
        create: (context) =>
            ManagementBloc(managementRepository: managementRepository),
        child: ListView(
          children: [
            PaginatedTable(
              title: l10n.adminManagement,
              headers: colHeader,
              dataSource: _DataSource(context),
            ),
          ],
        ),
      ),
    );
  }
}

class DataTableDemo extends StatelessWidget {
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        PaginatedDataTable(
          header: Text('Header Text'),
          rowsPerPage: 2,
          columns: [
            DataColumn(label: Text('Header A')),
            DataColumn(label: Text('Header B')),
            DataColumn(label: Text('Header C')),
            DataColumn(label: Text('Header D')),
          ],
          source: _DataSource(context),
        ),
      ],
    );
  }
}

class _Row {
  _Row(
    this.valueA,
    this.valueB,
    this.valueC,
    this.valueD,
  );

  final String valueA;
  final String valueB;
  final String valueC;
  final int valueD;

  //bool selected = false;
}

class _DataSource extends DataTableSource {
  _DataSource(this.context) {
    _rows = <_Row>[
      _Row('Cell A1', 'CellB1', 'CellC1', 1),
      _Row('Cell A2', 'CellB2', 'CellC2', 2),
      _Row('Cell A3', 'CellB3', 'CellC3', 3),
    ];
  }

  final BuildContext context;
  late List<_Row> _rows;

  // int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    // if (index >= _rows.length) return null;
    final row = _rows[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(row.valueA)),
        DataCell(Text(row.valueB)),
        DataCell(Text(row.valueC)),
        DataCell(Text(row.valueD.toString())),
      ],
    );
  }

  @override
  int get rowCount => _rows.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}

 

// class _DataSource extends DataTableSource {
//   _DataSource(this.context) {
//     _rows = <User>[
//       User(id: 'sss', email: '0000'),
//       User(id: '22222', email: '0000'),
//     ];
//   }
//   final BuildContext context;
//   List<User> _rows;

//   int _selectedCount = 0;

//   @override
//   DataRow? getRow(int index) {
//     assert(index >= 0);
//     if (index >= _rows.length) return null;
//     final row = _rows[index];
//     return DataRow.byIndex(
//       index: index,
//       //selected: row.selected,
//       // onSelectChanged: (value) {
//       //   if (row.selected != value) {
//       //     _selectedCount += value ? 1 : -1;
//       //     assert(_selectedCount >= 0);
//       //     row.selected = value;
//       //     notifyListeners();
//       //   }
//       // },
//       cells: [
//         DataCell(Text(row.id)),
//         DataCell(Text(row.email.toString())),
//       ],
//     );
//   }

//   @override
//   int get rowCount => _rows.length;

//   @override
//   bool get isRowCountApproximate => false;

//   @override
//   int get selectedRowCount => _selectedCount;
// }
