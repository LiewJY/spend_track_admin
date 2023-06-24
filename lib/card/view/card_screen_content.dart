import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_admin/card/bloc/card_bloc.dart';
import 'package:track_admin/card/card.dart';
import 'package:track_admin/card/view/card_data_table.dart';
import 'package:track_admin/category/category.dart';
import 'package:track_admin/l10n/l10n.dart';
import 'package:track_admin/repositories/models/cashback.dart';
import 'package:track_admin/repositories/repos/card/card_repository.dart';
import 'package:track_admin/repositories/repos/category/category_repository.dart';
import 'package:track_admin/widgets/widgets.dart';
import 'package:track_theme/track_theme.dart';

class CardScreenContent extends StatelessWidget {
  const CardScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cardRepository = CardRepository();
    final categoryRepository = CategoryRepository();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: cardRepository,
        ),
        RepositoryProvider.value(
          value: categoryRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => CardBloc(cardRepository: cardRepository),
          ),
          BlocProvider(
            create: (context) =>
                CategoryBloc(categoryRepository: categoryRepository),
          ),
        ],
        child: ListView(children: [
          PageTitleText(title: l10n.card),
          StepperFormLoader(),
        ]),
      ),
    );
  }
}

class StepperFormLoader extends StatefulWidget {
  const StepperFormLoader({super.key});

  @override
  State<StepperFormLoader> createState() => _StepperFormLoaderState();
}

class _StepperFormLoaderState extends State<StepperFormLoader> {
  @override
  void initState() {
    super.initState();
    //load data from firebase
    context.read<CardBloc>().add(DisplayAllCardRequested());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    refresh() {
      //call load data function
      context.read<CategoryBloc>().add(DisplayAllCategoryRequested());
    }

    return BlocListener<CardBloc, CardState>(
      listener: (context, state) {
        if (state.status == CardStatus.failure) {
          switch (state.error) {
            // case 'email-already-exists':
            //   AppSnackBar.error(context, l10n.emailAlreadyInUse);
            //   break;
            //todo
            default:
              AppSnackBar.error(context, l10n.unknownError);
          }
        }
        if (state.status == CategoryStatus.success) {
          switch (state.success) {
            case 'added':
              // if (isDialogOpen) {
              //   Navigator.of(context, rootNavigator: true).pop();
              // }
              // AppSnackBar.success(context, l10n.addedAdmin);
              // refresh();
              //todo
              break;
            case 'updated':
              // if (isDialogOpen) {
              //   Navigator.of(context, rootNavigator: true).pop();
              // }
              // AppSnackBar.success(context, l10n.categoryUpdatedSuccess);
              // refresh();
              //todo
              break;
            case 'deleted':
              // AppSnackBar.success(context, l10n.catxegoryDeleteSuccess);
              // refresh();
              //todo
              break;
          }
        }
      },
      child: CardDataTable(),
    );
  }
}
