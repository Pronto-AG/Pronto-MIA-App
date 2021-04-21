import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/app/app.router.dart';
import 'package:pronto_mia/app/theme.dart';
import 'package:pronto_mia/ui/views/startup/startup_view.dart';

void main() async {
  setupLocator();
  runApp(MyApp());
}

// TODO: Override error widget
// TODO: Override error handler

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pronto-MIA',
      navigatorKey: StackedService.navigatorKey,
      onGenerateRoute: StackedRouter().onGenerateRoute,
      home: StartUpView(),
      theme: theme,
      debugShowCheckedModeBanner: false,
    );
  }
}
