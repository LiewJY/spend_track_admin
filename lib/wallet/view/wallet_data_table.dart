import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_admin/l10n/l10n.dart';
import 'package:track_admin/repositories/models/wallet.dart';
import 'package:track_admin/wallet/wallet.dart';
import 'package:track_admin/widgets/widgets.dart';
import 'package:track_theme/track_theme.dart';

class WalletDataTable extends StatefulWidget {
  const WalletDataTable({super.key});

  @override
  State<WalletDataTable> createState() => _WalletDataTableState();
}

//for dialog
bool isDialogOpen = false;
void toggleDialog() {
  isDialogOpen = !isDialogOpen;
}

class _WalletDataTableState extends State<WalletDataTable> {
  //column sorting function
  int sortColumnIndex = 0;
  bool isAscending = true;

  //for pagination
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  //sorting
  onsortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        filterWalletData!.sort((a, b) => a.name!.compareTo(b.name!));
      } else {
        filterWalletData!.sort((a, b) => b.name!.compareTo(a.name!));
      }
    }
  }

  //todo will use if have clear option
  TextEditingController searchController = TextEditingController();
  void clear() {
    walletData = filterWalletData!.toList();
    searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    refresh() {
      //call load data function
      context.read<WalletBloc>().add(DisplayAllWalletRequested());
    }

    List<DataColumn> column = [
      DataColumn(
        label: Text(
          l10n.walletName,
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
    return BlocListener<WalletBloc, WalletState>(
      listener: (context, state) {
        if (state.status == WalletStatus.failure) {
          switch (state.error) {
            // case 'email-already-exists':
            //   AppSnackBar.error(context, l10n.emailAlreadyInUse);
            //   break;
            default:
              AppSnackBar.error(context, l10n.unknownError);
          }
        }
        if (state.status == WalletStatus.success) {
          switch (state.success) {
            case 'added':
              if (isDialogOpen) {
                Navigator.of(context, rootNavigator: true).pop();
              }
              AppSnackBar.success(context, l10n.walletAddSuccess);
              refresh();
              break;
            case 'updated':
              if (isDialogOpen) {
                Navigator.of(context, rootNavigator: true).pop();
              }
              AppSnackBar.success(context, l10n.walletUpdatedSuccess);
              refresh();
              break;
            case 'deleted':
              AppSnackBar.success(context, l10n.walletDeleteSuccess);
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
                  hintText: l10n.searchByWalletName,
                  controller: searchController,
                  action: (value) {
                    setState(() {
                      walletData = filterWalletData!
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
                            value: BlocProvider.of<WalletBloc>(context),
                            child: WalletDialog(
                              dialogTitle: l10n.addWallet,
                              actionName: l10n.add,
                              action: 'addWallet',
                            ),
                          );
                        }).then((value) {
                      toggleDialog();
                    });
                    toggleDialog();
                  }
                },
                child: Text(l10n.addWallet),
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
        source: RowSource(walletData!, context),
      ),
    );
  }
}

//data source
class RowSource extends DataTableSource {
  //extract the data param passed
  final List<Wallet> walletData;
  final BuildContext context;

  RowSource(this.walletData, this.context);

  @override
  DataRow? getRow(int index) {
    if (index < rowCount) {
      return recentFileDataRow(walletData![index]);
    } else
      return null;
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => walletData.length;

  @override
  int get selectedRowCount => 0;
}

DataRow recentFileDataRow(Wallet data) {
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
                      child: Text(l10n.editWallet),
                    ),
                    PopupMenuItem(
                      value: 1,
                      child: Text(l10n.deleteWallet),
                    ),
                  ];
                },
                onSelected: (value) {
                  switch (value) {
                    case 0:
                      editWallet(data, context);
                      break;
                    case 1:
                      deleteWallet(data, context);
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

void editWallet(Wallet data, BuildContext context) {
  final l10n = context.l10n;
  if (!isDialogOpen) {
    showDialog(
        context: context,
        builder: (_) {
          return BlocProvider.value(
            value: BlocProvider.of<WalletBloc>(context),
            child: WalletDialog(
              dialogTitle: l10n.editWallet,
              actionName: l10n.update,
              action: 'editWallet',
              data: data,
            ),
          );
        }).then((value) {
      toggleDialog();
    });
    toggleDialog();
  }
}

void deleteWallet(Wallet data, BuildContext context) {
  final l10n = context.l10n;
  if (!isDialogOpen) {
    showDialog(
        context: context,
        builder: (_) {
          return DeleteConfirmationDialog(
              data: data,
              description: l10n.deleting(data.name!),
              dialogTitle: l10n.delete,
              action: () {
                context
                    .read<WalletBloc>()
                    .add(DeleteWalletRequested(uid: data.uid!));

                Navigator.of(context, rootNavigator: true).pop();
              });
        }).then((value) {
      toggleDialog();
    });
    toggleDialog();
  }
}
