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
        body: (() {
          if (model.hasError) {
            return Center(
              child: Text(model.errorMessage),
            );
          }

          return Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'assets/images/pronto_icon.png',
                ),
              ],
            ),
          );
        })(),
      ),
    );
  }
}
