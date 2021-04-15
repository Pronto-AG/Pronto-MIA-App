import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';

import 'package:pronto_mia/ui/views/deployment_plan/deployment_plan_viewmodel.dart';

class DeploymentPlanView extends StatelessWidget {
  final bool adminModeEnabled;
  final void Function() toggleAdminModeCallback;

  const DeploymentPlanView({
    Key key,
    @required this.adminModeEnabled,
    @required this.toggleAdminModeCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DeploymentPlanViewModel>.reactive(
      viewModelBuilder: () => DeploymentPlanViewModel(adminModeEnabled: adminModeEnabled),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Einsatzpläne'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.admin_panel_settings),
              tooltip: 'Administrator-Modus',
              onPressed: () {
                model.toggleAdminMode();
                toggleAdminModeCallback();
              },
              color: (() {
                if (model.adminModeEnabled) {
                  return Colors.yellow;
                } else {
                  return null;
                }
              })(),
            ),
            const IconButton(
              icon: Icon(Icons.account_circle),
              tooltip: 'Benutzerprofil',
            ),
          ],
        ),
        body: (() {
          if (model.isBusy) {
            return const Center(
              child: CircularProgressIndicator()
            );
          }

          if (model.hasError) {
            return Center(
              child: Text(model.errorMessage)
            );
          }

          return ListView.builder(
              itemCount: model.data.length,
              itemBuilder: (context, index) {
                final dateFormat = DateFormat('dd.MM.yyyy');
                final availableFromFormatted =
                  dateFormat.format(model.data[index].availableFrom);
                final availableUntilFormatted =
                  dateFormat.format(model.data[index].availableUntil);

                return Card(
                  child: ListTile(
                    title: Text('Einsatzplan $availableFromFormatted'),
                    subtitle: Text('gültig bis $availableUntilFormatted'),
                    onTap: () => model.openPdf(model.data[index]),
                  ),
                );
              }
          );
        })()
      ),
    );
  }
}
