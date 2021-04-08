import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'package:pronto_mia/ui/views/deployment_plan/deployment_plan_viewmodel.dart';

class DeploymentPlanView extends StatelessWidget {
  const DeploymentPlanView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DeploymentPlanViewModel>.reactive(
      viewModelBuilder: () => DeploymentPlanViewModel(),
      builder: (context, model, child) {
        if (model.isBusy) {
          return const Center(
            child: CircularProgressIndicator()
          );
        }

        if (model.hasError) {
          return Center(
            child: Text('Fehler'),
          );
        }

        return ListView.builder(
          itemCount: model.data.length,
          itemBuilder: (context, index) => ListTile(
            title: Text('Einsatzplan $index'),
          ),
        );
      },
    );
  }
}
