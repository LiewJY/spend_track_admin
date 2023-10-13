import 'package:flutter/material.dart';
import 'package:track_theme/track_theme.dart';

class StepperContainer extends StatelessWidget {
  const StepperContainer({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: AppStyle.dialogMaxWidth,
        child: child,
      ),
    );
  }
}
