import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_admin/app/bloc/app_bloc.dart';
import 'package:track_admin/l10n/l10n.dart';
import 'package:track_admin/widgets/widgets.dart';

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
//  final webViewController = WebViewController()
//     ..loadRequest(Uri.parse('https://deadsimplechat.com/IyL5YkDM3'));

    //user's informaiton
    final user = context.select((AppBloc bloc) => bloc.state.user);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageTitleText(
          title: l10n.hi(user.name ?? ''),
        ),
        Expanded(child: Dashboard())
        // WebViewWidget(controller: webViewController)
      ],
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final IFrameElement _iFrameElement = IFrameElement();
  @override
  void initState() {
    _iFrameElement.style.height = '100%';
    _iFrameElement.style.width = '100%';
    _iFrameElement.src = 'https://lookerstudio.google.com/embed/u/0/reporting/39b5339e-8225-41b2-b350-b81a58eb0ebf/page/Gg3';
    _iFrameElement.style.border = 'none';

// ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'iframeElement',
      (int viewId) => _iFrameElement,
    );

    super.initState();
  }

  final Widget _iframeWidget = HtmlElementView(
    viewType: 'iframeElement',
    key: UniqueKey(),
  );
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: _iframeWidget,
    );
  }
}
