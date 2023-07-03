import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_admin/category/bloc/category_bloc.dart';
import 'package:track_admin/category/category.dart';
import 'package:track_admin/l10n/l10n.dart';
import 'package:track_admin/management/view/management_screen_content.dart';
import 'package:track_admin/repositories/models/category.dart';
import 'package:track_admin/repositories/models/wallet.dart';
import 'package:track_admin/repositories/repositories.dart';
import 'package:track_admin/wallet/wallet.dart';
import 'package:track_admin/widgets/widgets.dart';

import '../../repositories/models/user.dart';
import 'package:firebase_admin/firebase_admin.dart';

class WalletScreenContent extends StatelessWidget {
  const WalletScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final walletRepository = WalletRepository();

    return RepositoryProvider.value(
      value: walletRepository,
      child: BlocProvider(
        create: (context) => WalletBloc(walletRepository: walletRepository),
        child: ListView( 
          children: [
            PageTitleText(title: l10n.wallet),
            WalletDataLoader(),
          ],
        ),
      ),
    );
  }
}

//list from firebase
List<Wallet>? filterWalletData;
List<Wallet>? walletData;

class WalletDataLoader extends StatefulWidget {
  const WalletDataLoader({super.key});

  @override
  State<WalletDataLoader> createState() => _WalletDataLoaderState();
}

class _WalletDataLoaderState extends State<WalletDataLoader> {
  @override
  void initState() {
    super.initState();
    //load data from firebase
    context.read<WalletBloc>().add(DisplayAllWalletRequested());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    walletData = context.select((WalletBloc bloc) => bloc.state.walletList);

    filterWalletData = walletData!;
    return BlocListener<WalletBloc, WalletState>(
      listener: (context, state) {
        if (state.status == WalletStatus.failure) {
          switch (state.error) {
            case 'cannotRetrieveData':
              AppSnackBar.error(context, l10n.cannotRetrieveData);
              break;
          }
        }
        if (state.status == WalletStatus.success) {
          switch (state.success) {
            case 'loadedData':
              //reload the data table when data is loaded
              setState(() {});
              break;
          }
        }
      },
      child: WalletDataTable(),
    );
  }
}
