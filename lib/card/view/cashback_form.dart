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
  // : super(key: key);

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
  TextEditingController _descController = TextEditingController();
    TextEditingController _aController = TextEditingController();

  //hide show diff rate with min spend
  bool _isRateDifferent = false;
  //hide show capped at rate
  bool _isCapped = false;
  //todo
  late String _categoryType;
  late String _spendingDay;

  //day list
  // List<bool> _daySelections = List.generate(7, (_) => false);

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
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CategoryDropDownField(
                        // items: dropdownItems,
                        onChanged: (value) {
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
                //todo
                if (_isRateDifferent) ...[
                  NameField(controller: _descController),
                ] else
                  ...[],
                AppStyle.sizedBoxSpace,
              ],
            ),
          )),
    );
  }

  bool validate() {
    if (cashbackForm.currentState!.validate()) {
      cashbackForm.currentState?.save();
      return true;
    }
    return false;
  }
}
