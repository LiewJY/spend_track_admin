import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_admin/l10n/l10n.dart';
import 'package:track_admin/management/management.dart';
import 'package:track_admin/repositories/models/user.dart';
import 'package:track_admin/repositories/repositories.dart';
import 'package:track_admin/widgets/widgets.dart';

import '../../widgets/snackbar.dart';

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
            PageTitleText(title: l10n.adminManagement),
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
    final l10n = context.l10n;
    myData = context.select((ManagementBloc bloc) => bloc.state.adminUsersList);

    filterData = myData!;
    return BlocListener<ManagementBloc, ManagementState>(
      listener: (context, state) {
        if (state.status == ManagementStatus.failure) {
          switch (state.error) {
            case 'cannotRetrieveData':
              AppSnackBar.error(context, l10n.cannotRetrieveData);
              break;
          }
        }
        if (state.status == ManagementStatus.success) {
          switch (state.success) {
            case 'loadedData':
              //reload the data table when data is loaded
              setState(() {});
              break;
          }
        }
      },
      child: AdminDataTable(),
    );
  }
}
