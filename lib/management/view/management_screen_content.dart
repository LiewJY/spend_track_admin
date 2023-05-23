import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_admin/management/management.dart';
import 'package:track_admin/repositories/models/user.dart';
import 'package:track_admin/repositories/repositories.dart';

class ManagementScereenContent extends StatelessWidget {
  const ManagementScereenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final managementRepository = ManagementRepository();
    return RepositoryProvider.value(
      value: managementRepository,
      child: BlocProvider(
        create: (context) =>
            ManagementBloc(managementRepository: managementRepository),
        child: View(),
      ),
    );
  }
}

class View extends StatefulWidget {
  const View({
    super.key,
  });

  @override
  State<View> createState() => _ViewState();
}

class _ViewState extends State<View> {
  @override
  Widget build(BuildContext context) {
    List<User> aa =
        context.select((ManagementBloc bloc) => bloc.state.adminUsersList);

    // class aa {

    // }

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        ElevatedButton(onPressed: () => loadTable(), child: Text('lala')),
        PaginatedDataTable(
            header: Text('table header'),
            columns: [
              DataColumn(
                label: Text('uiddd'),
                // onSort: (columnIndex, ascending) =>
                //     _sort<String>((d) => d.name, columnIndex, ascending),
              ),
            ],
            source: _source),

        // PaginatedDataTable(
        //     columns: <DataColumn>[
        //       DataColumn(
        //         label: Text('fffff'),
        //       ),
        //     ],
        //     //source: DataTableSource(aa, 1),
        //     )
        //?    sssssssssssssssssssssssssssssssssssss

        //           DataTable(columns: <DataColumn>[
        //             DataColumn(label: Text('fffff'))
        //           ], rows: <DataRow>[
        //             DataRow(cells: [
        //                         DataCell(Text('ffffsd')),]
        // )
        //           ]),
      ],
    );
  }

  loadTable() {
    context.read<ManagementBloc>().add(DisplayAllAdminRequested());
  }
}

// class _source extends DataTableSource {
//   _source(this.context) {
//     _user = <User>[
//       User(id: '1111111'),
//             User(id: '22222'),

//     ];
//   }

//   final BuildContext context;
//   late List<User> _user;


//     @override
//   DataRow? getRow(int index) {
//     // final int pageIndex = index ~/ rowsPerPage;
//     // final int pageOffset = index % rowsPerPage;
//     // final int currentPageFirstRowIndex = pageIndex * rowsPerPage;

//     // if (currentPageFirstRowIndex + pageOffset >= adminDataList.length) {
//     //   return null;
//     // }

//     // final adminData = adminDataList[currentPageFirstRowIndex + pageOffset];

//     return DataRow(cells: [
//      // DataCell(Text(adminData.id)),

//     ]);
//   }
// }

// class _AdminDataTableSource extends DataTableSource {
//   final List<User> adminDataList;
//   final int rowsPerPage;
//   int currentPage = 0;

//   _AdminDataTableSource(this.adminDataList, this.rowsPerPage);

//   @override
//   DataRow? getRow(int index) {
//     final int pageIndex = index ~/ rowsPerPage;
//     final int pageOffset = index % rowsPerPage;
//     final int currentPageFirstRowIndex = pageIndex * rowsPerPage;

//     if (currentPageFirstRowIndex + pageOffset >= adminDataList.length) {
//       return null;
//     }

//     final adminData = adminDataList[currentPageFirstRowIndex + pageOffset];

//     return DataRow(cells: [
//       DataCell(Text(adminData.id)),
//       DataCell(Text(adminData.email ?? '')),
//     ]);
//   }

//  @override
//   int get rowCount => _desserts.length;

//   @override
//   bool get isRowCountApproximate => false;

//   @override
//   int get selectedRowCount => _selectedCount;
// }
