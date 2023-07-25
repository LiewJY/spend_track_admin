import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_admin/card/bloc/card_bloc.dart';
import 'package:track_admin/card/card.dart';
import 'package:track_admin/category/category.dart';
import 'package:track_admin/l10n/l10n.dart';
import 'package:track_admin/repositories/models/cashback.dart';
import 'package:track_admin/repositories/models/creditCard.dart';
import 'package:track_admin/widgets/dialog/card_dialog.dart';
import 'package:track_admin/widgets/widgets.dart';
import 'package:track_theme/track_theme.dart';

class CardDataTable extends StatefulWidget {
  const CardDataTable({super.key});

  @override
  State<CardDataTable> createState() => _CardDataTableState();
}

//for dialog
bool isDialogOpen = false;
void toggleDialog() {
  isDialogOpen = !isDialogOpen;
}

class _CardDataTableState extends State<CardDataTable> {
  //column sorting function
  int sortColumnIndex = 0;
  bool isAscending = true;

  //for pagination
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  //sorting
  onsortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        filterCardData!.sort((a, b) => a.name!.compareTo(b.name!));
      } else {
        filterCardData!.sort((a, b) => b.name!.compareTo(a.name!));
      }
    }
  }

  //todo will use if have clear option
  TextEditingController searchController = TextEditingController();
  void clear() {
    myCardData = filterCardData!.toList();
    searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    refresh() {
      //call load data function
      context.read<CardBloc>().add(DisplayAllCardRequested());
    }

    List<DataColumn> column = [
      DataColumn(
        label: Text(
          l10n.name,
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
          l10n.cardType,
          style: AppStyle.dtHeader,
        ),
      ),
      DataColumn(
        label: Text(
          l10n.bank,
          style: AppStyle.dtHeader,
        ),
      ),
      DataColumn(
        label: Text(
          l10n.cashback,
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

    return BlocListener<CardBloc, CardState>(
      listener: (context, state) {
        if (state.status == CardStatus.failure) {
          switch (state.error) {
            default:
              AppSnackBar.error(context, l10n.unknownError);
          }
        }
        if (state.status == CardStatus.success) {
          switch (state.success) {
            case 'added':
              if (isDialogOpen) {
                Navigator.of(context, rootNavigator: true).pop();
              }
              AppSnackBar.success(context, l10n.cardAddSuccess);
              refresh();
              break;
            case 'updated':
              if (isDialogOpen) {
                Navigator.of(context, rootNavigator: true).pop();
              }
              AppSnackBar.success(context, l10n.cardUpdateSuccess);
              refresh();
              break;
            case 'deleted':
              AppSnackBar.success(context, l10n.cardDeleteSuccess);
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
                      myCardData = filterCardData!
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
                          return MultiBlocProvider(
                            providers: [
                              BlocProvider.value(
                                value: BlocProvider.of<CardBloc>(context),
                              ),
                              BlocProvider.value(
                                value: BlocProvider.of<CategoryBloc>(context),
                              ),
                            ],
                            child: CardDialog(
                              dialogTitle: l10n.addCard,
                              // actionName: l10n.add,
                              action: 'addCard',
                            ),
                          );
                        }).then((value) {
                      toggleDialog();
                    });
                    toggleDialog();
                  }
                },
                child: Text(l10n.addCard),
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
        source: RowSource(myCardData!, context),
      ),
    );
  }
}

//data source
class RowSource extends DataTableSource {
  //extract the data param passed
  final List<CreditCard> cardData;
  final BuildContext context;

  RowSource(this.cardData, this.context);

  @override
  DataRow? getRow(int index) {
    if (index < rowCount) {
      return recentFileDataRow(cardData![index]);
    } else
      return null;
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => cardData.length;

  @override
  int get selectedRowCount => 0;
}

DataRow recentFileDataRow(CreditCard data) {
  return DataRow(
    cells: [
      DataCell(Text(
        data.name ?? "",
      )),
      DataCell(Text(
        data.cardType ?? "",
      )),
      DataCell(Text(
        data.bank ?? "",
      )),
      DataCell(
        data.isCashback! ? const Icon(Icons.check) : Text(''),
      ),
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
                    //todo
                    // PopupMenuItem(
                    //   value: 0,
                    //   child: Text(l10n.viewCard),
                    // ),
                    // PopupMenuItem(
                    //   value: 1,
                    //   child: Text(l10n.editCard),
                    // ),
                    PopupMenuItem(
                      value: 2,
                      child: Text(l10n.deleteCard),
                    ),
                  ];
                },
                onSelected: (value) {
                  switch (value) {
                    //todo
                    case 0:
                      //viewCard(data, context);
                      break;
                    case 1:
                      // editCard(data, context);
                      break;
                    case 2:
                      deleteCard(data, context);
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

void deleteCard(CreditCard data, BuildContext context) {
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
                    .read<CardBloc>()
                    .add(DeleteCardRequested(uid: data.uid!));
                Navigator.of(context, rootNavigator: true).pop();
              });
        }).then((value) {
      toggleDialog();
    });
    toggleDialog();
  }
}

// void editCard(CreditCard data, BuildContext context) {
//   final l10n = context.l10n;
//   //query cashback data
//   //List<Cashback>? cashbackData;
//   // context.read<CardBloc>().add(DisplayCardCashbackRequested(uid: data.uid!));

//   if (!isDialogOpen) {
//     showDialog(
//         context: context,
//         builder: (_) {
//           return MultiBlocProvider(
//             providers: [
//               BlocProvider.value(
//                 value: BlocProvider.of<CardBloc>(context),
//               ),
//               BlocProvider.value(
//                 value: BlocProvider.of<CategoryBloc>(context),
//               ),
//             ],
//             child: CardDialog(
//               dialogTitle: l10n.editCard,
//               // actionName: l10n.update,
//               action: 'editCard',
//               data: data,
//             ),
//           );
//         }).then((value) {
//       toggleDialog();
//     });
//     toggleDialog();
//   }
// }
