import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';

import 'package:pronto_mia/ui/views/deployment_plan/overview/deployment_plan_overview_viewmodel.dart';

class DeploymentPlanOverviewView extends StatelessWidget {
  final bool adminModeEnabled;
  final void Function() toggleAdminModeCallback;

  const DeploymentPlanOverviewView({
    Key key,
    @required this.adminModeEnabled,
    @required this.toggleAdminModeCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DeploymentPlanOverviewViewModel>.reactive(
      viewModelBuilder: () => DeploymentPlanOverviewViewModel(
        adminModeEnabled: adminModeEnabled,
      ),
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
            IconButton(
              icon: const Icon(Icons.account_circle),
              tooltip: 'Benutzerprofil',
              onPressed: () {},
            ),
          ],
        ),
        body: (() {
          if (model.isBusy) {
            return const Center(child: CircularProgressIndicator());
          }

          // TODO: Add image to error
          if (model.hasError) {
            return Center(
              child: Text(model.errorMessage),
            );
          }

          return ListView.builder(
              itemCount: model.data.length,
              itemBuilder: (context, index) {
                final dateFormat = DateFormat('dd.MM.yyyy hh:mm');
                final availableFromFormatted =
                    dateFormat.format(model.data[index].availableFrom);
                final availableUntilFormatted =
                    dateFormat.format(model.data[index].availableUntil);

                return Card(
                  child: ListTile(
                    // TODO: Add description
                    title: Text('Einsatzplan $availableFromFormatted'),
                    subtitle: Text(
                        ' $availableFromFormatted - $availableUntilFormatted'),
                    onTap: () => model.openPdf(model.data[index]),
                  ),
                );
              });
        })(),
        floatingActionButton: (() {
          if (model.adminModeEnabled) {
            return FloatingActionButton(
              tooltip: 'Einsatzplan erstellen',
              onPressed: model.createDeploymentPlan,
              child: const Icon(Icons.post_add),
            );
          }
        })(),
      ),
    );
  }
}
