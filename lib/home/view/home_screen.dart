import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_admin/card/view/card_screen_content.dart';
import 'package:track_admin/category/category.dart';
import 'package:track_admin/l10n/l10n.dart';
import 'package:track_admin/management/management.dart';
import 'package:track_admin/repositories/repositories.dart';
import 'package:track_admin/home/home.dart';
import 'package:track_admin/setting/setting.dart';
import 'package:track_admin/user/user.dart';
import 'package:track_theme/track_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  //for routing
  static Page<void> page() => const MaterialPage<void>(child: HomeScreen());

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //fixme
  int currentPageIndex = 2;
  //repos
  final authRepository = AuthRepository();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: SafeArea(
          child: Row(
        children: [
          NavigationRail(
            selectedIndex: currentPageIndex,
            onDestinationSelected: (index) {
              setState(() {
                currentPageIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: [
              NavigationRailDestination(
                  icon: Icon(Icons.home), label: Text(l10n.home)),
              NavigationRailDestination(
                  icon: Icon(Icons.category), label: Text(l10n.category)),
              NavigationRailDestination(
                  icon: Icon(Icons.credit_card), label: Text(l10n.card)),
              NavigationRailDestination(
                  icon: Icon(Icons.person), label: Text(l10n.management)),
              NavigationRailDestination(
                  icon: Icon(Icons.group), label: Text(l10n.users)),
              NavigationRailDestination(
                  icon: Icon(Icons.settings), label: Text(l10n.setting)),
            ],
          ),
          Expanded(
            child: Padding(
              padding: AppStyle.paddingWebBody,
              child: <Widget>[
                HomeScreenContent(),
                CategoryScereenContent(),
                CardScreenContent(),
                ManagementScreenContent(),
                UserScreen(),
                SettingScreenContent(),
              ][currentPageIndex],
            ),
          ),
        ],
      )),
    );
  }
}
