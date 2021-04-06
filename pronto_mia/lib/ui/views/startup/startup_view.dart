import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'package:pronto_mia/ui/views/startup/startup_viewmodel.dart';

class StartUpView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartUpViewModel>.reactive(
      viewModelBuilder: () => StartUpViewModel(),
      onModelReady: (model) => model.handleStartUp(),
      builder: (context, model, child) => Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: 300,
                height: 100,
                child: Image.asset('assets/images/pronto_logo.png'),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: CircularProgressIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}