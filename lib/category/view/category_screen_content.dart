import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:track_admin/l10n/l10n.dart';
import 'package:track_admin/widgets/widgets.dart';

class CategoryScereenContent extends StatelessWidget {
  const CategoryScereenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      //color: Colors.amber,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PageTitleText(title: l10n.category),
              FilledButton(
                onPressed: () => todo(),
                child: Text(l10n.add),
              ),
            ],
          ),
          //todo
        ],
      ),
    );
  }

  todo() {}
}
