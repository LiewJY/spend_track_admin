import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:track_admin/l10n/l10n.dart';
import 'package:track_admin/repositories/models/cashback.dart';
import 'package:track_theme/track_theme.dart';

class CashbackReviewCard extends StatelessWidget {
  CashbackReviewCard({super.key, required this.element});

  Cashback element;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final bool rate = element.isRateDifferent!;
    final bool capped = element.isCapped!;

    return Container(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: AppStyle.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${l10n.category}:  ${element.category}'),
              Text('${l10n.spendingDay}:  ${element.spendingDay}'),
              if (rate) ...[
                Text('${l10n.differentCashbackRate} ${l10n.no}'),
                Text('${l10n.minSpendAmount} : RM ${element.minSpend}'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${l10n.minSpendAchieved}% : '),
                          Text('${element.minSpendAchieved}%'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${l10n.minSpendNotAchieved}% : '),
                          Text('${element.minSpendNotAchieved}%'),
                        ],
                      ),
                    )
                  ],
                )
              ] else ...[
                Text('${l10n.differentCashbackRate} ${l10n.yes}'),
                Text(
                    '${l10n.cashback}% : ${element.cashback}%'),
              ],
              if (capped) ...[
                Text('${l10n.cashbackCapped} ${l10n.yes}'),
                Text('${l10n.amountCappedAt} : RM ${element.cappedAt}'),
              ] else ...[
                Text('${l10n.amountCappedAt} ${l10n.no}'),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
