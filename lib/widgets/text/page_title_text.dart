import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:track_admin/l10n/l10n.dart';

class PageTitleText extends StatelessWidget {
  const PageTitleText({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        //fixme better options
        Padding(padding: EdgeInsets.only(left: 2)),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
          //textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
