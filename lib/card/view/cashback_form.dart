import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_admin/category/category.dart';
import 'package:track_admin/l10n/l10n.dart';

import 'package:track_admin/repositories/models/cashback.dart';
import 'package:track_admin/repositories/models/category.dart';
import 'package:track_admin/widgets/widgets.dart';
import 'package:track_theme/track_theme.dart';

class DynamicCashbackForm extends StatefulWidget {
  DynamicCashbackForm({
    //  Key key,
    super.key,
    this.index,
    this.cashbackModel,
    this.onRemove,
  });

  final index;
  Cashback? cashbackModel;
  final onRemove;
  final state = _DynamicCashbackFormState();

  @override
  State<DynamicCashbackForm> createState() {
    return state;
  }

  //facilitate multiform validation
  bool isValidated() => state.validate();
}

class _DynamicCashbackFormState extends State<DynamicCashbackForm> {
  @override
  void initState() {
    super.initState();
  }

  final cashbackForm = GlobalKey<FormState>();
  // TextEditingController _descController = TextEditingController();
  // TextEditingController _aController = TextEditingController();

  TextEditingController _cashbackController = TextEditingController();
  TextEditingController _minSpendController = TextEditingController();
  TextEditingController _minSpendAchievedController = TextEditingController();
  TextEditingController _minSpendNotAchievedController =
      TextEditingController();
  TextEditingController _cappedAtController = TextEditingController();

  //hide show diff rate with min spend
  bool _isRateDifferent = false;
  //hide show capped at rate
  bool _isCapped = true;
  late String _categoryType;
  late String _spendingDay;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Form(
          key: cashbackForm,
          child: Padding(
            padding: AppStyle.cardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CategoryDropDownField(onChanged: (value) {
                      _categoryType = value;
                    }),
                    Padding(
                      padding: AppStyle.dtButonHorizontalPadding,
                      child: IconButton(
                        onPressed: widget.onRemove,
                        icon: const Icon(Icons.delete),
                      ),
                    ),
                  ],
                ),
                AppStyle.sizedBoxSpace,
                SpendingDayDropDownField(onChanged: (value) {
                  setState(() {
                    _spendingDay = value;
                  });
                }),
                AppStyle.sizedBoxSpace,
                SwitchField(
                    label: l10n.differentCashbackRate,
                    switchState: _isRateDifferent,
                    onChanged: (value) {
                      setState(() {
                        _isRateDifferent = value;
                      });
                    }),
                AppStyle.sizedBoxSpace,
                if (_isRateDifferent) ...[
                  Text(
                    l10n.cashbackWhen,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  AppStyle.sizedBoxSpace,
                  AmountField(
                    controller: _minSpendController,
                    label: l10n.minSpendAmount,
                  ),
                  AppStyle.sizedBoxSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CashbackPercentField(
                          controller: _minSpendAchievedController,
                          label: l10n.minSpendAchieved,
                        ),
                      ),
                      //todo move to style
                      SizedBox(width: 10),
                      Expanded(
                        child: CashbackPercentField(
                          controller: _minSpendNotAchievedController,
                          label: l10n.minSpendNotAchieved,
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  //cashback rate no difference (extra with min spend)
                  CashbackPercentField(
                    controller: _cashbackController,
                    label: l10n.cashback,
                  ),
                ],
                AppStyle.sizedBoxSpace,
                SwitchField(
                    label: l10n.cashbackCapped,
                    switchState: _isCapped,
                    onChanged: (value) {
                      setState(() {
                        _isCapped = value;
                      });
                    }),
                if (_isCapped) ...[
                  AppStyle.sizedBoxSpace,
                  AmountField(
                    controller: _cappedAtController,
                    label: l10n.amountCappedAt,
                  ),
                ]
              ],
            ),
          )),
    );
  }

  double? stringToDounble(value) {
    return double.tryParse(value);
  }

  bool validate() {
    if (cashbackForm.currentState!.validate()) {
      widget.cashbackModel = Cashback(
        category: _categoryType,
        spendingDay: _spendingDay,
        isRateDifferent: _isRateDifferent,
        minSpend: stringToDounble(_minSpendController.text),
        minSpendAchieved: stringToDounble(_minSpendAchievedController.text),
        minSpendNotAchieved: stringToDounble(_minSpendAchievedController.text),
        cashback: stringToDounble(_cashbackController.text),
        isCapped: _isCapped,
        cappedAt: stringToDounble(_cappedAtController.text),
      );
      cashbackForm.currentState?.save();
      return true;
    }
    return false;
  }
}
