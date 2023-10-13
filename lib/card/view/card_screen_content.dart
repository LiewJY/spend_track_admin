import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_admin/card/bloc/card_bloc.dart';
import 'package:track_admin/card/card.dart';
import 'package:track_admin/card/view/card_data_table.dart';
import 'package:track_admin/category/category.dart';
import 'package:track_admin/l10n/l10n.dart';
import 'package:track_admin/repositories/models/cashback.dart';
import 'package:track_admin/repositories/models/creditCard.dart';
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
          CardDataLoader(),
          //StepperFormLoader(),
        ]),
      ),
    );
  }
}

//list from firebase
List<CreditCard>? filterCardData;
List<CreditCard>? myCardData;

class CardDataLoader extends StatefulWidget {
  const CardDataLoader({super.key});

  @override
  State<CardDataLoader> createState() => _CardDataLoaderState();
}

class _CardDataLoaderState extends State<CardDataLoader> {
  @override
  void initState() {
    super.initState();
    //load data from firebase
    context.read<CardBloc>().add(DisplayAllCardRequested());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    myCardData = context.select((CardBloc bloc) => bloc.state.cardList);

    filterCardData = myCardData!;
    return BlocListener<CardBloc, CardState>(
      listener: (context, state) {
        if (state.status == CardStatus.failure) {
          switch (state.error) {
            case 'cannotRetrieveData':
              AppSnackBar.error(context, l10n.cannotRetrieveData);
              break;
          }
        }
        if (state.status == CardStatus.success) {
          switch (state.success) {
            case 'loadedData':
              //reload the data table when data is loaded
              setState(() {});
              break;
          }
        }
      },
      child: CardDataTable(),
      //child: TestStepper(),
    );
  }
}







//todo move to another page
// class StepperFormLoader extends StatefulWidget {
//   const StepperFormLoader({super.key});

//   @override
//   State<StepperFormLoader> createState() => _StepperFormLoaderState();
// }

// class _StepperFormLoaderState extends State<StepperFormLoader> {
//   @override
//   void initState() {
//     super.initState();
//     //load data from firebase
//     context.read<CardBloc>().add(DisplayAllCardRequested());
//   }

//   @override
//   Widget build(BuildContext context) {
//     final l10n = context.l10n;

//     refresh() {
//       //call load data function
//       context.read<CategoryBloc>().add(DisplayAllCategoryRequested());
//     }

//     return BlocListener<CardBloc, CardState>(
//       listener: (context, state) {
//         if (state.status == CardStatus.failure) {
//           switch (state.error) {
//             case 'cannotRetrieveData':
//               AppSnackBar.error(context, l10n.cannotRetrieveData);
//               break;
//           }
//         }
//         if (state.status == CategoryStatus.success) {
//           switch (state.success) {
//             case 'loadedData':
//               //reload the data table when data is loaded
//               setState(() {});
//               break;
//           }
//         }
//       },
//       child: CardDataTable(),
//     );
//   }
// }
