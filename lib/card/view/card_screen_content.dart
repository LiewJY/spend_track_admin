import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:track_admin/l10n/l10n.dart';
import 'package:track_admin/widgets/widgets.dart';
import 'package:track_theme/track_theme.dart';

class CardScreenContent extends StatelessWidget {
  const CardScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return TestStepper();
  }
}


class TestStepper extends StatefulWidget {
  const TestStepper({super.key});

  @override
  State<TestStepper> createState() => _TestStepperState();
}

class _TestStepperState extends State<TestStepper> {
  int currentStep = 0;
  bool isCompleted = false;
  final formKey = GlobalKey<FormState>();
  //text field controllers
  final _nameController = TextEditingController();
  final _bankController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Stepper(
      steps: steps(l10n),
      //type: StepperType.horizontal,
      currentStep: currentStep,
      onStepTapped: (int index) {
        //formKey.currentState!.validate();
        setState(() {
          currentStep = index;
        });
      },
      onStepContinue: () {
        final isLastStep = currentStep == steps(l10n).length - 1;
        //formKey.currentState!.validate();
        //bool isDetailValid = isDetailComplete();
        //if (isDetailValid) {
        if (isLastStep) {
          setState(() {
            isCompleted = true;
          });
        } else {
          setState(() {
            currentStep += 1;
          });
        }
        //}
      },
      onStepCancel: () {
        if (currentStep == 0) {
          null;
        } else {
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
          content: Container(
            alignment: Alignment.bottomLeft,
            child: ConstrainedBox(
              constraints: AppStyle.dialogMaxWidth,
              child: Form(
                  child: Column(
                children: [
                  AppStyle.sizedBoxSpace,
                  NameField(controller: _nameController),
                  AppStyle.sizedBoxSpace,
                  BankField(controller: _bankController),
                  AppStyle.sizedBoxSpace,
                  //todo
                ],
              )),
            ),
          ),
        ),
        Step(
          title: Text('Step 2 title'),
          content: Container(
            alignment: Alignment.topLeft,
            child: Text('Content for Step 2'),
          ),
        ),
        Step(
          title: Text('Step 3 title'),
          content: Container(
            alignment: Alignment.topLeft,
            child: Text('Content for Step 3'),
          ),
        ),
      ];
}
