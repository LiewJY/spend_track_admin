import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_admin/l10n/l10n.dart';
import 'package:track_admin/repositories/models/user.dart';
import 'package:track_admin/repositories/repositories.dart';
import 'package:track_admin/user/bloc/user_bloc.dart';
import 'package:track_admin/user/user.dart';
import 'package:track_admin/widgets/widgets.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final userRepository = UserRepository();
    return RepositoryProvider.value(
      value: userRepository,
      child: BlocProvider(
        create: (context) => UserBloc(userRepository: userRepository),
        child: ListView(
          children: [
            PageTitleText(title: l10n.userManagement),
            UserDataLoader(),
          ],
        ),
      ),
    );
  }
}

//list from firebase
List<User>? filterData;
List<User>? myData;

class UserDataLoader extends StatefulWidget {
  const UserDataLoader({super.key});

  @override
  State<UserDataLoader> createState() => _UserDataLoaderState();
}

class _UserDataLoaderState extends State<UserDataLoader> {
  @override
  void initState() {
    super.initState();
    //load data from firebase
    context.read<UserBloc>().add(DisplayAllUserRequested());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    myData = context.select((UserBloc bloc) => bloc.state.usersList);
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state.status == UserStatus.failure) {
          switch (state.error) {
            case 'cannotRetrieveData':
              AppSnackBar.error(context, l10n.cannotRetrieveData);
              break;
          }
        }
        if (state.status == UserStatus.success) {
          switch (state.success) {
            case 'loadedData':
              //reload the data table when data is loaded
              setState(() {});
              break;
          }
        }
      },
      child: UserDataTable(),
    );
  }
}
