import 'package:flutter/material.dart';

import 'package:track_admin/repositories/models/cashback.dart';
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
  //final state = _DynamicCashbackForm();

  //form field
  TextEditingController _nameController = TextEditingController();

  @override
  State<DynamicCashbackForm> createState() => _DynamicCashbackFormState();
}

class _DynamicCashbackFormState extends State<DynamicCashbackForm> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _descController = TextEditingController();

  //hide show diff rate with min spend
  bool _isRateDifferent = false;
  //hide show capped at rate
  bool _isCapped = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Form(
          child: Padding(
        padding: AppStyle.cardPadding,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //DropDownField(items: items, onChanged: onChanged)
                //todo dropdown

                IconButton(
                  onPressed: widget.onRemove,
                  icon: Icon(Icons.delete),
                ),
              ],
            ),
            AppStyle.sizedBoxSpace,
            NameField(controller: widget._nameController),
            AppStyle.sizedBoxSpace,
            NameField(controller: _descController),
            SwitchField(
                label: 'test ',
                switchState: _isRateDifferent,
                onChanged: (value) {
                  setState(() {
                    _isRateDifferent = value;
                  });
                }),
            if (_isRateDifferent) ...[
              NameField(controller: widget._nameController),
            ],
            AppStyle.sizedBoxSpace,
          ],
        ),
      )),
    );
  }
}
