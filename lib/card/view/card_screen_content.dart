import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_admin/card/bloc/card_bloc.dart';
import 'package:track_admin/card/card.dart';
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
    return StepperFormLoader();
  }
}

class StepperFormLoader extends StatefulWidget {
  const StepperFormLoader({super.key});

  @override
  State<StepperFormLoader> createState() => _StepperFormLoaderState();
}

class _StepperFormLoaderState extends State<StepperFormLoader> {
  @override
  Widget build(BuildContext context) {
    //create single instance of card repo
    final cardRepository = CardRepository();
    final categoryRepository = CategoryRepository();
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: cardRepository,
        ),
        RepositoryProvider(
          create: (context) => categoryRepository,
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
        child: TestStepper(),
      ),
    );
  }
}

class TestStepper extends StatefulWidget {
  const TestStepper({super.key});

  @override
  State<TestStepper> createState() => _TestStepperState();
}

class _TestStepperState extends State<TestStepper> {
  int currentStep = 1;
  bool isCompleted = false;

  // final cashbackInformationForm = GlobalKey<FormState>(debugLabel: 'cashback');

  //multiple form states
  final List<GlobalKey<FormState>> formKeys = [];
  late GlobalKey<FormState> basicInformationForm;
  late GlobalKey<FormState> cashbackInformationForm;

  @override
  void initState() {
    super.initState();
    // Create a new GlobalKey and assign to a variable for each form.

    formKeys.add(GlobalKey<FormState>());
    formKeys.add(GlobalKey<FormState>());
    basicInformationForm = formKeys[0];
    cashbackInformationForm = formKeys[1];
  }

  //text field controllers
  //basic form
  final _nameController = TextEditingController();
  final _bankController = TextEditingController();
  String? _cardType;
  bool _isCashback = true;

  //cashback form
  final List<DynamicCashbackForm> cashbackForms = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    bool validate() {
      if (currentStep == 0) {
        //fixme remove later
        // context.read<CardBloc>().add(AddCardRequested(
        //       name: _nameController.text,
        //       bank: _bankController.text,
        //       cardType: _cardType.toString(),
        //       isCashback: _isCashback,
        //     ));
        return basicInformationForm.currentState!.validate();
      } else if (currentStep == 1) {
        bool allValid = true;
        cashbackForms.forEach(
          (element) => allValid = (allValid && element.isValidated()),
        );
        return allValid;
      }
      return basicInformationForm.currentState!.validate();
    }

    final l10n = context.l10n;
    return Stepper(
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
      controlsBuilder: (BuildContext context, ControlsDetails details) {
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
          title: Text('Step 3 title'),
          content: Container(
            alignment: Alignment.topLeft,
            child: Text('Content for Step 3'),
          ),
        ),
      ];

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
                    child: Text('add aad jjkjjjn '),
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
            CardTypeDropDownField(onChanged: (value) {
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
            // ElevatedButton(
            //     onPressed: () {
            //       log('cardtype ' + _cardType.toString());
            //     },
            //     child: Text('ddd')),
            AppStyle.sizedBoxSpace,
          ],
        ));
  }
}
