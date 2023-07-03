import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_admin/card/bloc/card_bloc.dart';
import 'package:track_admin/card/card.dart';
import 'package:track_admin/l10n/l10n.dart';
import 'package:track_admin/repositories/models/cashback.dart';
import 'package:track_admin/repositories/models/creditCard.dart';
import 'package:track_admin/widgets/widgets.dart';
import 'package:track_theme/track_theme.dart';

class CardDialog extends StatefulWidget {
  const CardDialog({
    super.key,
    required this.dialogTitle,
    // required this.actionName,
    required this.action,
    this.data,
  });

  final String dialogTitle;
  // final String actionName;
  final String action;
  final CreditCard? data;

  @override
  State<CardDialog> createState() => _CardDialogState();
}

List<Cashback>? cashbackData = [];

class _CardDialogState extends State<CardDialog> {
  @override
  void initState() {
    super.initState();
    //load data from firebase (cashbacks data)
    if (widget.action == 'editCard') {
      context
          .read<CardBloc>()
          .add(DisplayCardCashbackRequested(uid: widget.data!.uid!));
    }
  }

  @override
  Widget build(BuildContext context) {
    cashbackData = context.select((CardBloc bloc) => bloc.state.cashbackList);

    return BlocListener<CardBloc, CardState>(
      listener: (context, state) {
        if (state.status == CardStatus.success) {
          switch (state.success) {
            case 'cashbackLoaded':
              // setState(() {});
              break;
          }
        }
      },
      child: CardStepperForm(
        dialogTitle: widget.dialogTitle,
        action: widget.action,
        data: widget.data,
      ),
    );
  }
}

class CardStepperForm extends StatefulWidget {
  const CardStepperForm({
    super.key,
    required this.dialogTitle,
    // required this.actionName,
    required this.action,
    this.data,
    // this.cashbackList,
  });

  final String dialogTitle;
  // final String actionName;
  final String action;
  final CreditCard? data;
  // final List<Cashback>? cashbackList;
  @override
  State<CardStepperForm> createState() => _CardStepperFormState();
}

class _CardStepperFormState extends State<CardStepperForm> {
  int currentStep = 0;
  bool isCompleted = false;

  //multiple form states
  final List<GlobalKey<FormState>> formKeys = [];
  late GlobalKey<FormState> basicInformationForm;
  late GlobalKey<FormState> cashbackInformationForm;

  //text field controllers
  //basic form
  final _nameController = TextEditingController();
  final _bankController = TextEditingController();
  String? _cardType;
  bool _isCashback = true;

  //cashback form
  final List<DynamicCashbackForm> cashbackForms = [];

  //list of cashback
  List<Cashback> cashbacks = [];

  @override
  void initState() {
    super.initState();
    // Create a new GlobalKey and assign to a variable for each form.

    formKeys.add(GlobalKey<FormState>());
    formKeys.add(GlobalKey<FormState>());
    basicInformationForm = formKeys[0];
    cashbackInformationForm = formKeys[1];

    //set data for edit / update option
    if (widget.action == 'editCard') {
      //todo
      _nameController.text = widget.data!.name!;
      _bankController.text = widget.data!.bank!;
      _isCashback = widget.data!.isCashback!;
      _cardType = widget.data!.cardType!;
      //widget.data.uid
      // log('for each');
      // cashbackData?.forEach((element) {
      //   log(element.toString());
      // });
      // print('lengtj ssss ' + cashbackData!.length.toString());

      //query cashbacks
    }

    //todo add cashbackfrom add option to pump in modal if it is edit
    //onAddCashbackForm();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (widget.action == 'editCard') {
      //==print('lengtj ssss ' + cashbackData!.length.toString());
    }

    action(type) {
      switch (type) {
        case 'addCard':
          context.read<CardBloc>().add(AddCardRequested(
                name: _nameController.text,
                bank: _bankController.text,
                cardType: _cardType.toString(),
                isCashback: _isCashback,
                cashbacks: cashbacks,
              ));
          break;
        case 'editCard':
          //todo

          break;
      }
    }

    bool validate() {
      if (currentStep == 0) {
        return basicInformationForm.currentState!.validate();
      } else if (currentStep == 1) {
        bool allValid = true;
        for (var element in cashbackForms) {
          allValid = (allValid && element.isValidated());
        }
        if (allValid) {
          cashbacks = [];
          for (var element in cashbackForms) {
            cashbacks.add(Cashback(
              formId: element.index,
              categoryId: element.cashbackModel?.categoryId,
              category: element.cashbackModel?.category,
              spendingDay: element.cashbackModel?.spendingDay,
              isRateDifferent: element.cashbackModel?.isRateDifferent,
              minSpend: element.cashbackModel?.minSpend,
              minSpendAchieved: element.cashbackModel?.minSpendAchieved,
              minSpendNotAchieved: element.cashbackModel?.minSpendNotAchieved,
              cashback: element.cashbackModel?.cashback,
              isCapped: element.cashbackModel?.isCapped,
              cappedAt: element.cashbackModel?.cappedAt,
            ));
          }
        }
        return allValid;
      }
      return basicInformationForm.currentState!.validate();
    }

    return Dialog(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: AppStyle.dialogMaxWidth * 1.5,
          child: Padding(
            padding: AppStyle.modalPadding,
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      widget.dialogTitle,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
                Stepper(
                  steps: steps(l10n),
                  currentStep: currentStep,
                  onStepTapped: (int index) {
                    if (validate()) {
                      setState(() {
                        currentStep = index;
                      });
                    }
                  },
                  onStepContinue: () {
                    final isLastStep = currentStep == steps(l10n).length - 1;
                    if (validate()) {
                      if (isLastStep) {
                        setState(() {
                          isCompleted = true;
                        });
                        //add / update the card
                        action(widget.action);
                      } else {
                        //skip step 2
                        if (currentStep == 0 && _isCashback == false) {
                          setState(() {
                            currentStep += 1;
                          });
                        }
                        setState(() {
                          currentStep += 1;
                        });
                      }
                    }
                  },
                  onStepCancel: () {
                    if (currentStep == 0) {
                      null;
                    } else {
                      //skip step 2
                      if (currentStep == 2 && _isCashback == false) {
                        setState(() {
                          currentStep -= 1;
                        });
                      }
                      setState(() {
                        currentStep -= 1;
                      });
                    }
                  },
                  controlsBuilder:
                      (BuildContext context, ControlsDetails details) {
                    final isLastStep = currentStep == steps(l10n).length - 1;
                    return Row(children: [
                      ElevatedButton(
                        child: Text(l10n.back),
                        onPressed: details.onStepCancel,
                      ),
                      //todo place into style file
                      SizedBox(width: 10),
                      FilledButton(
                        child: Text(isLastStep ? l10n.complete : l10n.next),
                        onPressed: details.onStepContinue,
                      ),
                    ]);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Step> steps(l10n) => [
        Step(
          title: Text(l10n.basicInformation),
          content: StepperContainer(child: basicForm(l10n)),
        ),
        Step(
          state: _isCashback ? StepState.indexed : StepState.disabled,
          title: Text(l10n.cashbackInformation),
          content: StepperContainer(child: cashbackForm(l10n)),
        ),
        Step(
          title: Text(l10n.reviewCardInformation),
          content: StepperContainer(child: reviewCard(l10n)),
        ),
      ];

  reviewCard(l10n) {
    return Column(
      children: [
        OutlineCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                child: Padding(
                  padding: AppStyle.cardPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.name + ':  ' + _nameController.text),
                      Text(l10n.bank + ':  ' + _bankController.text),
                      Text(l10n.cardType + ':  ' + _cardType.toString()),
                      //iterate
                      for (var item in cashbacks)
                        CashbackReviewCard(element: item)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        AppStyle.sizedBoxSpace,
      ],
    );
  }

  Form cashbackForm(l10n) {
    return Form(
        key: cashbackInformationForm,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AppStyle.sizedBoxSpace,
            cashbackForms.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: cashbackForms.length,
                    itemBuilder: (_, index) {
                      return cashbackForms[index];
                    })
                : Center(
                    child: Text(l10n.addCashbackForm),
                  ),
            AppStyle.sizedBoxSpace,
            OutlinedButton(
              onPressed: () {
                onAddCashbackForm();
              },
              child: Text(l10n.add),
            ),
            AppStyle.sizedBoxSpace,
          ],
        ));
  }

  //Delete specific form
  onRemoveCashbackForm(Cashback cashbackInformation) {
    setState(() {
      int index = cashbackForms.indexWhere((element) =>
          element.cashbackModel?.formId == cashbackInformation.formId);

      if (cashbackForms != null) cashbackForms.removeAt(index);
    });
  }

  onAddCashbackForm() {
    setState(() {
      Cashback _cashback = Cashback(formId: cashbackForms.length);
      cashbackForms.add(DynamicCashbackForm(
        index: cashbackForms.length,
        cashbackModel: _cashback,
        onRemove: () => onRemoveCashbackForm(_cashback),
      ));
    });
  }

  Form basicForm(l10n) {
    return Form(
        key: basicInformationForm,
        child: Column(
          children: [
            AppStyle.sizedBoxSpace,
            NameField(controller: _nameController),
            AppStyle.sizedBoxSpace,
            BankField(controller: _bankController),
            AppStyle.sizedBoxSpace,
            CardTypeDropDownField(
                value: _cardType,
                onChanged: (value) {
                  _cardType = value;
                }),
            AppStyle.sizedBoxSpace,
            SwitchField(
                label: l10n.doesCardHaveCashback,
                switchState: _isCashback,
                onChanged: (value) {
                  setState(() {
                    _isCashback = value;
                  });
                }),
            AppStyle.sizedBoxSpace,
          ],
        ));
  }
}
